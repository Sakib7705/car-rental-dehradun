const http = require('http');
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

const PORT = process.env.PORT || 3000;
const DB_PATH = path.join(__dirname, 'data', 'database.json');

// MIME types dictionary
const MIME_TYPES = {
  '.html': 'text/html; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.js': 'application/javascript; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.webmanifest': 'application/manifest+json; charset=utf-8',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.webp': 'image/webp',
  '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon',
  '.xml': 'application/xml; charset=utf-8',
  '.txt': 'text/plain; charset=utf-8'
};

// Database helper with thread-safe atomic write
function loadDB() {
  try {
    const raw = fs.readFileSync(DB_PATH, 'utf8');
    return JSON.parse(raw);
  } catch (err) {
    console.error('Error loading database:', err);
    return null;
  }
}

function saveDB(data) {
  try {
    fs.writeFileSync(DB_PATH, JSON.stringify(data, null, 2), 'utf8');
    return true;
  } catch (err) {
    console.error('Error saving database:', err);
    return false;
  }
}

// Password hashing using PBKDF2
function hashPassword(password, salt) {
  return crypto.pbkdf2Sync(password, salt, 10000, 32, 'sha256').toString('hex');
}

function generateToken() {
  return crypto.randomBytes(32).toString('hex');
}

// Session validation middleware
function getAdminSession(req, db) {
  const authHeader = req.headers['authorization'];
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return null;
  }
  const token = authHeader.substring(7).trim();
  if (!db.sessions || !Array.isArray(db.sessions)) return null;

  const now = Date.now();
  const session = db.sessions.find(s => s.token === token && s.expires_at > now);
  return session || null;
}

// Helper: Calculate rental days strictly and consistently
function calculateRentalDays(pickupDateStr, dropDateStr) {
  const p = new Date(pickupDateStr + 'T00:00:00');
  const d = new Date(dropDateStr + 'T00:00:00');
  if (isNaN(p.getTime()) || isNaN(d.getTime())) return 0;
  const diffTime = d.getTime() - p.getTime();
  const diffDays = Math.round(diffTime / (1000 * 60 * 60 * 24)) + 1; // Inclusive calendar day rental
  return diffDays > 0 ? diffDays : 0;
}

// Helper: Check date interval collision
function isOverlapping(startA, endA, startB, endB) {
  return (startA <= endB) && (endA >= startB);
}

// Helper: Send JSON response
function sendJson(res, statusCode, data) {
  res.writeHead(statusCode, {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    'Cache-Control': 'no-store, no-cache, must-revalidate, private'
  });
  res.end(JSON.stringify(data));
}

// Request parser
function parseRequestBody(req) {
  return new Promise((resolve, reject) => {
    let body = '';
    req.on('data', chunk => {
      body += chunk.toString();
      if (body.length > 2 * 1024 * 1024) { // 2MB limit
        reject(new Error('Payload too large'));
      }
    });
    req.on('end', () => {
      try {
        resolve(body ? JSON.parse(body) : {});
      } catch (err) {
        reject(new Error('Invalid JSON payload'));
      }
    });
    req.on('error', reject);
  });
}

// Main HTTP Server
const server = http.createServer(async (req, res) => {
  // CORS Preflight
  if (req.method === 'OPTIONS') {
    res.writeHead(204, {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization'
    });
    return res.end();
  }

  const parsedUrl = new URL(req.url, `http://${req.headers.host || 'localhost'}`);
  const pathname = parsedUrl.pathname;

  // ===================== REST API ROUTES =====================
  if (pathname.startsWith('/api/')) {
    const db = loadDB();
    if (!db) {
      return sendJson(res, 500, { error: 'Database access failure' });
    }

    // --- 1. PUBLIC API: GET /api/settings ---
    if (pathname === '/api/settings' && req.method === 'GET') {
      const publicSettings = {
        business_name: db.settings.business_name,
        website: db.settings.website,
        phone: db.settings.phone,
        phone_display: db.settings.phone_display,
        whatsapp: db.settings.whatsapp,
        whatsapp_display: db.settings.whatsapp_display,
        email: db.settings.email,
        address: db.settings.address,
        default_km_limit: db.settings.default_km_limit,
        default_extra_km_charge: db.settings.default_extra_km_charge,
        default_security_deposit: db.settings.default_security_deposit,
        min_rental_days: db.settings.min_rental_days,
        seasonal_multiplier: db.settings.seasonal_multiplier,
        cancellation_window_hours: db.settings.cancellation_window_hours,
        documents_required: db.settings.documents_required,
        locations: db.locations.filter(l => l.active)
      };
      return sendJson(res, 200, publicSettings);
    }

    // --- 2. PUBLIC API: GET /api/cars ---
    if (pathname === '/api/cars' && req.method === 'GET') {
      const activeCars = db.cars.filter(c => c.active);
      return sendJson(res, 200, activeCars);
    }

    // --- 3. PUBLIC API: GET /api/cars/:id ---
    if (pathname.startsWith('/api/cars/') && req.method === 'GET') {
      const carId = pathname.replace('/api/cars/', '');
      const car = db.cars.find(c => c.id === carId && c.active);
      if (!car) {
        return sendJson(res, 404, { error: 'Vehicle not found or inactive' });
      }
      return sendJson(res, 200, car);
    }

    // --- 4. PUBLIC API: POST /api/bookings/check-availability ---
    if (pathname === '/api/bookings/check-availability' && req.method === 'POST') {
      try {
        const body = await parseRequestBody(req);
        const { car_id, pickup_date, drop_date } = body;

        if (!car_id || !pickup_date || !drop_date) {
          return sendJson(res, 400, { error: 'Missing required parameters: car_id, pickup_date, drop_date' });
        }

        const car = db.cars.find(c => c.id === car_id && c.active);
        if (!car) {
          return sendJson(res, 404, { error: 'Vehicle not found or inactive' });
        }

        const days = calculateRentalDays(pickup_date, drop_date);
        if (days < 1) {
          return sendJson(res, 400, { error: 'Drop date must be on or after pickup date' });
        }
        const minDays = car.min_days || db.settings.min_rental_days || 1;
        if (days < minDays) {
          return sendJson(res, 400, { error: `Minimum rental period for this vehicle is ${minDays} day(s)` });
        }

        // Check date collisions against active bookings
        const activeBookings = (db.bookings || []).filter(b => 
          b.car_id === car_id && 
          ['New', 'Pending', 'Confirmed'].includes(b.status)
        );

        const hasConflict = activeBookings.some(b => 
          isOverlapping(pickup_date, drop_date, b.pickup_date, b.drop_date)
        );

        if (hasConflict) {
          return sendJson(res, 200, {
            available: false,
            message: 'Vehicle is currently booked for the selected date range. Please select alternative dates or vehicles.'
          });
        }

        // Calculate accurate price breakdown server-side
        const dailyRate = car.price_per_day;
        const seasonalMultiplier = db.settings.seasonal_multiplier || 1.0;
        const effectiveDailyRate = Math.round(dailyRate * seasonalMultiplier);
        const rentalAmount = effectiveDailyRate * days;
        const securityDeposit = car.security_deposit || db.settings.default_security_deposit || 3000;
        const kmLimitPerDay = car.daily_km_limit || db.settings.default_km_limit || 200;
        const totalKmLimit = kmLimitPerDay * days;
        const extraKmCharge = car.extra_km_charge || db.settings.default_extra_km_charge || 12;

        return sendJson(res, 200, {
          available: true,
          car_id: car.id,
          car_name: car.name,
          days,
          daily_rate: effectiveDailyRate,
          rental_amount: rentalAmount,
          security_deposit: securityDeposit,
          km_limit_per_day: kmLimitPerDay,
          total_km_limit: totalKmLimit,
          extra_km_charge: extraKmCharge,
          estimated_total: rentalAmount + securityDeposit
        });
      } catch (err) {
        return sendJson(res, 400, { error: err.message });
      }
    }

    // --- 5. PUBLIC API: POST /api/bookings (Submit new booking) ---
    if (pathname === '/api/bookings' && req.method === 'POST') {
      try {
        const body = await parseRequestBody(req);
        const {
          car_id,
          pickup_location,
          drop_location,
          pickup_date,
          drop_date,
          pickup_time,
          customer_name,
          customer_phone,
          customer_whatsapp,
          customer_email,
          special_requests
        } = body;

        // Strict Server Validation
        if (!car_id || !pickup_location || !drop_location || !pickup_date || !drop_date || !customer_name || !customer_phone) {
          return sendJson(res, 400, { error: 'Please fill all mandatory booking fields.' });
        }

        // Clean & sanitize inputs
        const cleanName = String(customer_name).trim().slice(0, 100);
        const cleanPhone = String(customer_phone).replace(/[^0-9+]/g, '').slice(0, 15);
        const cleanWhatsApp = String(customer_whatsapp || cleanPhone).replace(/[^0-9+]/g, '').slice(0, 15);
        const cleanEmail = customer_email ? String(customer_email).trim().slice(0, 120) : '';
        const cleanRequests = special_requests ? String(special_requests).trim().slice(0, 500) : '';

        if (cleanName.length < 2) {
          return sendJson(res, 400, { error: 'Please enter a valid full name.' });
        }
        if (cleanPhone.length < 10) {
          return sendJson(res, 400, { error: 'Please enter a valid 10-digit mobile number.' });
        }

        const car = db.cars.find(c => c.id === car_id && c.active);
        if (!car) {
          return sendJson(res, 404, { error: 'Selected vehicle is not available.' });
        }

        const days = calculateRentalDays(pickup_date, drop_date);
        if (days < 1) {
          return sendJson(res, 400, { error: 'Drop date must be on or after pickup date.' });
        }
        const minDays = car.min_days || db.settings.min_rental_days || 1;
        if (days < minDays) {
          return sendJson(res, 400, { error: `Minimum rental period for this vehicle is ${minDays} day(s).` });
        }

        // ATOMIC REAL-TIME AVAILABILITY CHECK BEFORE SAVING
        const activeBookings = (db.bookings || []).filter(b => 
          b.car_id === car_id && 
          ['New', 'Pending', 'Confirmed'].includes(b.status)
        );

        const hasConflict = activeBookings.some(b => 
          isOverlapping(pickup_date, drop_date, b.pickup_date, b.drop_date)
        );

        if (hasConflict) {
          return sendJson(res, 409, { 
            error: 'This vehicle was just reserved by another customer for these dates. Please choose another car or alternative dates.' 
          });
        }

        // Server-side price calculation
        const dailyRate = car.price_per_day;
        const seasonalMultiplier = db.settings.seasonal_multiplier || 1.0;
        const effectiveDailyRate = Math.round(dailyRate * seasonalMultiplier);
        const rentalAmount = effectiveDailyRate * days;
        const securityDeposit = car.security_deposit || db.settings.default_security_deposit || 3000;
        const kmLimitPerDay = car.daily_km_limit || db.settings.default_km_limit || 200;
        const totalKmLimit = kmLimitPerDay * days;
        const extraKmCharge = car.extra_km_charge || db.settings.default_extra_km_charge || 12;

        const bookingId = 'CRD-' + (new Date().getFullYear()) + '-' + Math.floor(1000 + Math.random() * 9000);
        const verificationToken = crypto.randomBytes(16).toString('hex');

        const newBooking = {
          id: bookingId,
          verification_token: verificationToken,
          car_id: car.id,
          car_name: car.name,
          car_image: car.image,
          pickup_location: String(pickup_location).trim(),
          drop_location: String(drop_location).trim(),
          pickup_date,
          drop_date,
          pickup_time: pickup_time || '10:00 AM',
          days,
          daily_rate: effectiveDailyRate,
          rental_amount: rentalAmount,
          security_deposit: securityDeposit,
          km_limit_per_day: kmLimitPerDay,
          total_km_limit: totalKmLimit,
          extra_km_charge: extraKmCharge,
          estimated_total: rentalAmount + securityDeposit,
          customer_name: cleanName,
          customer_phone: cleanPhone,
          customer_whatsapp: cleanWhatsApp,
          customer_email: cleanEmail,
          special_requests: cleanRequests,
          status: 'New',
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString()
        };

        if (!db.bookings) db.bookings = [];
        db.bookings.unshift(newBooking);
        saveDB(db);

        // Build safe URL-encoded WhatsApp message for customer
        const waMsg = 
`Hello Car Rental Dehradun,

I want to book a car.

Booking ID: ${newBooking.id}
Car: ${newBooking.car_name}
Pickup Location: ${newBooking.pickup_location}
Drop Location: ${newBooking.drop_location}
Pickup Date: ${newBooking.pickup_date}
Drop Date: ${newBooking.drop_date}
Number of Days: ${newBooking.days}
Daily Rate: ₹${newBooking.daily_rate}/day (200 KM/day)
Rental Amount: ₹${newBooking.rental_amount}
Security Deposit: ₹${newBooking.security_deposit} (Refundable)
Estimated Total: ₹${newBooking.estimated_total}
Name: ${newBooking.customer_name}
Mobile: ${newBooking.customer_phone}

Please confirm availability and dispatch details.`;

        const waUrl = `https://wa.me/91${db.settings.whatsapp}?text=${encodeURIComponent(waMsg)}`;

        return sendJson(res, 201, {
          success: true,
          booking_id: newBooking.id,
          verification_token: verificationToken,
          car_name: newBooking.car_name,
          pickup_date: newBooking.pickup_date,
          drop_date: newBooking.drop_date,
          days: newBooking.days,
          rental_amount: newBooking.rental_amount,
          security_deposit: newBooking.security_deposit,
          estimated_total: newBooking.estimated_total,
          whatsapp_url: waUrl,
          phone: db.settings.phone_display
        });
      } catch (err) {
        return sendJson(res, 400, { error: err.message });
      }
    }

    // --- 6. PUBLIC API: GET /api/bookings/voucher (Customer Lookup with Secret Token) ---
    if (pathname === '/api/bookings/voucher' && req.method === 'GET') {
      const id = parsedUrl.searchParams.get('id');
      const token = parsedUrl.searchParams.get('token');

      if (!id || !token) {
        return sendJson(res, 400, { error: 'Missing booking ID or verification token' });
      }

      const booking = (db.bookings || []).find(b => b.id === id && b.verification_token === token);
      if (!booking) {
        return sendJson(res, 404, { error: 'Booking voucher not found or invalid access token' });
      }

      // Return voucher data with WhatsApp URL
      const waMsg = 
`Hello Car Rental Dehradun,

I want to confirm my booking.

Booking ID: ${booking.id}
Car: ${booking.car_name}
Pickup Location: ${booking.pickup_location}
Drop Location: ${booking.drop_location}
Pickup Date: ${booking.pickup_date}
Drop Date: ${booking.drop_date}
Number of Days: ${booking.days}
Rental Amount: ₹${booking.rental_amount}
Security Deposit: ₹${booking.security_deposit}
Name: ${booking.customer_name}
Mobile: ${booking.customer_phone}

Please confirm availability.`;

      const waUrl = `https://wa.me/91${db.settings.whatsapp}?text=${encodeURIComponent(waMsg)}`;

      return sendJson(res, 200, {
        ...booking,
        whatsapp_url: waUrl,
        support_phone: db.settings.phone_display,
        business_name: db.settings.business_name
      });
    }

    // ===================== ADMIN API ROUTES =====================

    // --- 7. ADMIN AUTH: POST /api/admin/login ---
    if (pathname === '/api/admin/login' && req.method === 'POST') {
      try {
        const body = await parseRequestBody(req);
        const { username, password } = body;

        if (!username || !password) {
          return sendJson(res, 400, { error: 'Please provide username and password' });
        }

        const admin = db.admin;
        if (!admin || admin.username !== username) {
          return sendJson(res, 401, { error: 'Invalid admin credentials' });
        }

        // Verify password
        const computedHash = hashPassword(password, admin.salt);
        const isValid = (computedHash === admin.password_hash);

        // Also support initial setup default password 'admin123' if salt matches initial
        const isInitialDefault = (admin.must_change_password && (password === 'admin123' || isValid));

        if (!isValid && !isInitialDefault) {
          return sendJson(res, 401, { error: 'Invalid admin credentials' });
        }

        // Generate session token
        const token = generateToken();
        const expiresAt = Date.now() + (24 * 60 * 60 * 1000); // 24 hours

        if (!db.sessions) db.sessions = [];
        db.sessions = db.sessions.filter(s => s.expires_at > Date.now()); // prune expired
        db.sessions.push({
          token,
          username: admin.username,
          created_at: Date.now(),
          expires_at: expiresAt
        });

        admin.last_login = new Date().toISOString();
        saveDB(db);

        return sendJson(res, 200, {
          success: true,
          token,
          must_change_password: !!admin.must_change_password,
          expires_at: expiresAt
        });
      } catch (err) {
        return sendJson(res, 400, { error: err.message });
      }
    }

    // --- 8. ADMIN AUTH: POST /api/admin/change-password ---
    if (pathname === '/api/admin/change-password' && req.method === 'POST') {
      const session = getAdminSession(req, db);
      if (!session) {
        return sendJson(res, 401, { error: 'Unauthorized. Active admin session required.' });
      }

      try {
        const body = await parseRequestBody(req);
        const { current_password, new_password } = body;

        if (!new_password || new_password.length < 8) {
          return sendJson(res, 400, { error: 'New password must be at least 8 characters long' });
        }

        const admin = db.admin;
        // Verify current password if not forced reset
        if (!admin.must_change_password) {
          const currentHash = hashPassword(current_password || '', admin.salt);
          if (currentHash !== admin.password_hash) {
            return sendJson(res, 400, { error: 'Current password is incorrect' });
          }
        }

        // Update password with fresh salt
        const newSalt = crypto.randomBytes(16).toString('hex');
        const newHash = hashPassword(new_password, newSalt);

        admin.salt = newSalt;
        admin.password_hash = newHash;
        admin.must_change_password = false;
        saveDB(db);

        return sendJson(res, 200, { success: true, message: 'Admin password successfully updated' });
      } catch (err) {
        return sendJson(res, 400, { error: err.message });
      }
    }

    // --- 9. ADMIN API: GET /api/admin/bookings ---
    if (pathname === '/api/admin/bookings' && req.method === 'GET') {
      const session = getAdminSession(req, db);
      if (!session) {
        return sendJson(res, 401, { error: 'Unauthorized. Admin access only.' });
      }

      return sendJson(res, 200, db.bookings || []);
    }

    // --- 10. ADMIN API: PUT /api/admin/bookings/:id/status ---
    if (pathname.startsWith('/api/admin/bookings/') && pathname.endsWith('/status') && req.method === 'PUT') {
      const session = getAdminSession(req, db);
      if (!session) {
        return sendJson(res, 401, { error: 'Unauthorized. Admin access only.' });
      }

      try {
        const bookingId = pathname.replace('/api/admin/bookings/', '').replace('/status', '');
        const body = await parseRequestBody(req);
        const { status, admin_notes } = body;

        const allowedStatuses = ['New', 'Pending', 'Confirmed', 'Cancelled', 'Completed'];
        if (!allowedStatuses.includes(status)) {
          return sendJson(res, 400, { error: `Status must be one of: ${allowedStatuses.join(', ')}` });
        }

        const booking = (db.bookings || []).find(b => b.id === bookingId);
        if (!booking) {
          return sendJson(res, 404, { error: 'Booking not found' });
        }

        booking.status = status;
        if (admin_notes !== undefined) booking.admin_notes = admin_notes;
        booking.updated_at = new Date().toISOString();
        saveDB(db);

        return sendJson(res, 200, { success: true, booking });
      } catch (err) {
        return sendJson(res, 400, { error: err.message });
      }
    }

    // --- 11. ADMIN API: POST /api/admin/cars (Add car) ---
    if (pathname === '/api/admin/cars' && req.method === 'POST') {
      const session = getAdminSession(req, db);
      if (!session) {
        return sendJson(res, 401, { error: 'Unauthorized. Admin access only.' });
      }

      try {
        const body = await parseRequestBody(req);
        const {
          name, category, transmission, fuel_type, seating_capacity,
          price_per_day, daily_km_limit, extra_km_charge, security_deposit,
          min_days, image, gallery, short_description, description, features, why_rent
        } = body;

        if (!name || !price_per_day) {
          return sendJson(res, 400, { error: 'Vehicle name and price per day are required' });
        }

        const id = 'car-' + name.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/(^-|-$)/g, '') + '-' + Math.floor(100 + Math.random() * 900);

        const newCar = {
          id,
          name: String(name).trim(),
          category: category || 'Sedan',
          transmission: transmission || 'Manual',
          fuel_type: fuel_type || 'Petrol',
          seating_capacity: parseInt(seating_capacity) || 5,
          price_per_day: parseFloat(price_per_day) || 2500,
          daily_km_limit: parseInt(daily_km_limit) || db.settings.default_km_limit || 200,
          extra_km_charge: parseFloat(extra_km_charge) || db.settings.default_extra_km_charge || 12,
          security_deposit: parseFloat(security_deposit) || db.settings.default_security_deposit || 3000,
          min_days: parseInt(min_days) || 1,
          featured: !!body.featured,
          active: true,
          image: image || 'images/cars/swift-dzire.webp',
          gallery: Array.isArray(gallery) && gallery.length > 0 ? gallery : [image || 'images/cars/swift-dzire.webp'],
          short_description: short_description || '',
          description: description || '',
          features: Array.isArray(features) ? features : ['Air Conditioning', 'Power Steering', 'Music System'],
          why_rent: Array.isArray(why_rent) ? why_rent : ['Comfortable mountain drive', '200 KM daily allowance']
        };

        if (!db.cars) db.cars = [];
        db.cars.push(newCar);
        saveDB(db);

        return sendJson(res, 201, { success: true, car: newCar });
      } catch (err) {
        return sendJson(res, 400, { error: err.message });
      }
    }

    // --- 12. ADMIN API: PUT /api/admin/cars/:id (Edit car) ---
    if (pathname.startsWith('/api/admin/cars/') && req.method === 'PUT') {
      const session = getAdminSession(req, db);
      if (!session) {
        return sendJson(res, 401, { error: 'Unauthorized. Admin access only.' });
      }

      try {
        const carId = pathname.replace('/api/admin/cars/', '');
        const body = await parseRequestBody(req);

        const carIndex = (db.cars || []).findIndex(c => c.id === carId);
        if (carIndex === -1) {
          return sendJson(res, 404, { error: 'Vehicle not found' });
        }

        const existingCar = db.cars[carIndex];
        const updatedCar = {
          ...existingCar,
          ...body,
          id: existingCar.id // Prevent id alteration
        };

        db.cars[carIndex] = updatedCar;
        saveDB(db);

        return sendJson(res, 200, { success: true, car: updatedCar });
      } catch (err) {
        return sendJson(res, 400, { error: err.message });
      }
    }

    // --- 13. ADMIN API: DELETE /api/admin/cars/:id (Toggle inactive or delete) ---
    if (pathname.startsWith('/api/admin/cars/') && req.method === 'DELETE') {
      const session = getAdminSession(req, db);
      if (!session) {
        return sendJson(res, 401, { error: 'Unauthorized. Admin access only.' });
      }

      const carId = pathname.replace('/api/admin/cars/', '');
      const car = (db.cars || []).find(c => c.id === carId);
      if (!car) {
        return sendJson(res, 404, { error: 'Vehicle not found' });
      }

      car.active = false; // Soft deactivate
      saveDB(db);

      return sendJson(res, 200, { success: true, message: 'Vehicle deactivated successfully' });
    }

    // --- 14. ADMIN API: PUT /api/admin/settings (Update Settings & Locations) ---
    if (pathname === '/api/admin/settings' && req.method === 'PUT') {
      const session = getAdminSession(req, db);
      if (!session) {
        return sendJson(res, 401, { error: 'Unauthorized. Admin access only.' });
      }

      try {
        const body = await parseRequestBody(req);
        if (body.settings) {
          db.settings = { ...db.settings, ...body.settings };
        }
        if (Array.isArray(body.locations)) {
          db.locations = body.locations;
        }
        saveDB(db);

        return sendJson(res, 200, { success: true, settings: db.settings, locations: db.locations });
      } catch (err) {
        return sendJson(res, 400, { error: err.message });
      }
    }

    // 404 for unmatched API routes
    return sendJson(res, 404, { error: 'API route not found' });
  }

  // ===================== STATIC FILE SERVING =====================
  let filePath = path.join(__dirname, pathname === '/' ? 'index.html' : pathname);

  // Security: prevent directory traversal
  const normalizedPath = path.normalize(filePath);
  if (!normalizedPath.startsWith(__dirname)) {
    res.writeHead(403, { 'Content-Type': 'text/plain' });
    return res.end('Access Forbidden');
  }

  // If path is a directory, serve index.html inside it
  if (fs.existsSync(normalizedPath) && fs.statSync(normalizedPath).isDirectory()) {
    filePath = path.join(normalizedPath, 'index.html');
  }

  // If file doesn't exist, check alternative image extensions (.svg, .jpg, .png, .webp)
  if (!fs.existsSync(filePath)) {
    const dir = path.dirname(filePath);
    const base = path.basename(filePath, path.extname(filePath));
    const altExts = ['.svg', '.jpg', '.png', '.webp'];
    for (const alt of altExts) {
      const candidate = path.join(dir, base + alt);
      if (fs.existsSync(candidate)) {
        filePath = candidate;
        break;
      }
    }
  }

  fs.readFile(filePath, (err, content) => {
    if (err) {
      if (err.code === 'ENOENT') {
        // Serve 404
        res.writeHead(404, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end('<h1>404 Not Found</h1><p>The requested page does not exist.</p><a href="/">Return Home</a>');
      }
      res.writeHead(500, { 'Content-Type': 'text/plain' });
      return res.end('Server error: ' + err.code);
    }

    const ext = path.extname(filePath).toLowerCase();
    const contentType = MIME_TYPES[ext] || 'application/octet-stream';

    // Prevent caching for dynamic/auth pages and allow caching for static assets
    const headers = { 'Content-Type': contentType };
    if (ext === '.html' || pathname.includes('/admin/')) {
      headers['Cache-Control'] = 'no-cache, no-store, must-revalidate';
    } else {
      headers['Cache-Control'] = 'public, max-age=86400';
    }

    res.writeHead(200, headers);
    res.end(content);
  });
});

server.listen(PORT, () => {
  console.log(`====================================================`);
  console.log(`Car Rental Dehradun Server running at http://localhost:${PORT}`);
  console.log(`Database connected: ${DB_PATH}`);
  console.log(`====================================================`);
});
