$dbPath = "d:\Car-rental-dehradun.com\data\database.json"
$apiJsPath = "d:\Car-rental-dehradun.com\js\api.js"

$dbRaw = [System.IO.File]::ReadAllText($dbPath, [System.Text.Encoding]::UTF8)
$db = $dbRaw | ConvertFrom-Json

# Normalize cars
$normalizedCars = @()
foreach ($c in $db.cars) {
    $normalizedCars += [PSCustomObject]@{
        id = $c.id
        name = $c.name
        category = $c.category
        transmission = $c.transmission
        fuel_type = $c.fuel_type
        fuel = $c.fuel_type
        seating_capacity = $c.seating_capacity
        seats = $c.seating_capacity
        price_per_day = $c.price_per_day
        daily_rate = $c.price_per_day
        daily_km_limit = $c.daily_km_limit
        extra_km_charge = $c.extra_km_charge
        security_deposit = $c.security_deposit
        min_days = $c.min_days
        featured = $c.featured
        active = $c.active
        image = $c.image
        image_url = $c.image
        gallery = $c.gallery
        short_description = $c.short_description
        description = $c.description
        features = $c.features
        why_rent = $c.why_rent
        available = $true
    }
}

$fleetJson = $normalizedCars | ConvertTo-Json -Depth 5
$settingsJson = $db.settings | ConvertTo-Json -Depth 5
$locationsJson = $db.locations | ConvertTo-Json -Depth 5

$header = @'
/**
 * Car Rental Dehradun - Client API Layer
 * Handles communication with REST API backend with resilient online/offline fallbacks,
 * Android APK support (file:/// context), and real-time booking validation.
 */

const PRODUCTION_API_URL = 'https://car-rental-dehradun.com/api';

// Full embedded fleet fallback guarantees the Android APK & web app load instantly with 0ms delay
const EMBEDDED_FLEET_FALLBACK = 
'@

$middle = @'
;

const EMBEDDED_SETTINGS_FALLBACK = 
'@

$middle2 = @'
;
EMBEDDED_SETTINGS_FALLBACK.locations = 
'@

$logic = @'
;

function resolveApiBase() {
  if (typeof window !== 'undefined') {
    const origin = window.location.origin;
    const protocol = window.location.protocol;
    // When running inside Android APK (file:///android_asset/...)
    if (protocol === 'file:' || !origin || origin === 'null' || origin.startsWith('file:')) {
      return PRODUCTION_API_URL;
    }
    // When served over HTTP/HTTPS (production domain or custom server)
    if (origin.startsWith('http://') || origin.startsWith('https://')) {
      return `${origin}/api`;
    }
  }
  return PRODUCTION_API_URL;
}

class ApiService {
  constructor() {
    this.tokenKey = 'crd_admin_token';
    this.apiBase = resolveApiBase();
  }

  getAuthHeaders() {
    const token = sessionStorage.getItem(this.tokenKey);
    const headers = { 'Content-Type': 'application/json' };
    if (token) {
      headers['Authorization'] = `Bearer ${token}`;
    }
    return headers;
  }

  isOnline() {
    return typeof navigator !== 'undefined' && navigator.onLine !== false;
  }

  async fetchJson(endpoint, options = {}, timeoutMs = 5000) {
    const url = `${this.apiBase}${endpoint}`;
    const controller = new AbortController();
    const timer = setTimeout(() => controller.abort(), timeoutMs);

    try {
      const res = await fetch(url, {
        ...options,
        signal: controller.signal,
        headers: {
          ...this.getAuthHeaders(),
          ...(options.headers || {})
        }
      });
      clearTimeout(timer);

      const data = await res.json().catch(() => ({}));
      if (!res.ok) {
        throw new Error(data.error || `Request failed with status ${res.status}`);
      }
      return data;
    } catch (err) {
      clearTimeout(timer);
      throw err;
    }
  }

  // --- Public APIs with Resilient Fallback ---

  async getSettings() {
    try {
      const settings = await this.fetchJson('/settings', {}, 4000);
      if (settings && settings.business_name) {
        try { localStorage.setItem('crd_settings_cache', JSON.stringify(settings)); } catch (e) {}
        return settings;
      }
    } catch (err) {
      console.warn('Live settings API unreachable, using cached/embedded settings:', err.message);
    }

    try {
      const cached = localStorage.getItem('crd_settings_cache');
      if (cached) return JSON.parse(cached);
    } catch (e) {}

    return EMBEDDED_SETTINGS_FALLBACK;
  }

  async getCars() {
    try {
      const cars = await this.fetchJson('/cars', {}, 4000);
      if (Array.isArray(cars) && cars.length > 0) {
        cars.forEach(c => {
          if (!c.image && c.image_url) c.image = c.image_url;
          if (!c.image_url && c.image) c.image_url = c.image;
        });
        try { localStorage.setItem('crd_cars_cache', JSON.stringify(cars)); } catch (e) {}
        return cars;
      }
    } catch (err) {
      console.warn('Live cars API unreachable, using cached/embedded fleet:', err.message);
    }

    try {
      const cached = localStorage.getItem('crd_cars_cache');
      if (cached) {
        const parsed = JSON.parse(cached);
        if (Array.isArray(parsed) && parsed.length > 0) return parsed;
      }
    } catch (e) {}

    return EMBEDDED_FLEET_FALLBACK;
  }

  async getCarById(id) {
    try {
      const car = await this.fetchJson(`/cars/${encodeURIComponent(id)}`, {}, 4000);
      if (car && car.id) {
        if (!car.image && car.image_url) car.image = car.image_url;
        if (!car.image_url && car.image) car.image_url = car.image;
        return car;
      }
    } catch (err) {
      console.warn(`Live car API for ${id} unreachable, using fallback:`, err.message);
    }

    const allCars = await this.getCars();
    const found = allCars.find(c => c.id === id);
    if (found) return found;
    throw new Error('Vehicle not found.');
  }

  async checkAvailability(carId, pickupDate, dropDate) {
    try {
      return await this.fetchJson('/bookings/check-availability', {
        method: 'POST',
        body: JSON.stringify({
          car_id: carId,
          pickup_date: pickupDate,
          drop_date: dropDate
        })
      }, 4000);
    } catch (err) {
      console.warn('Availability check unreachable, defaulting to available for instant WhatsApp booking:', err.message);
      return { available: true, message: 'Vehicle available for selected dates.' };
    }
  }

  async submitBooking(bookingData) {
    try {
      const result = await this.fetchJson('/bookings', {
        method: 'POST',
        body: JSON.stringify(bookingData)
      }, 5000);
      if (result && result.success) {
        return result;
      }
    } catch (err) {
      console.warn('Remote booking API offline or unreachable; queuing booking locally:', err.message);
    }

    // Generate local booking record so the user is never blocked
    const localId = `CRD-${Math.floor(100000 + Math.random() * 900000)}`;
    const savedBooking = {
      ...bookingData,
      id: localId,
      booking_id: localId,
      created_at: new Date().toISOString(),
      status: 'pending_whatsapp_confirmation',
      offline: true
    };

    try {
      const existing = JSON.parse(localStorage.getItem('crd_offline_bookings') || '[]');
      existing.unshift(savedBooking);
      localStorage.setItem('crd_offline_bookings', JSON.stringify(existing));
    } catch (e) {}

    return {
      success: true,
      booking_id: localId,
      booking: savedBooking,
      offline: true,
      message: 'Booking initialized. Please confirm via WhatsApp.'
    };
  }

  async getBookingVoucher(id, token) {
    try {
      return await this.fetchJson(`/bookings/voucher?id=${encodeURIComponent(id)}&token=${encodeURIComponent(token)}`);
    } catch (err) {
      try {
        const offline = JSON.parse(localStorage.getItem('crd_offline_bookings') || '[]');
        const found = offline.find(b => b.id === id || b.booking_id === id);
        if (found) return { booking: found, settings: EMBEDDED_SETTINGS_FALLBACK };
      } catch (e) {}
      throw err;
    }
  }

  // --- Admin APIs ---
  async adminLogin(username, password) {
    const data = await this.fetchJson('/admin/login', {
      method: 'POST',
      body: JSON.stringify({ username, password })
    });
    if (data.token) {
      sessionStorage.setItem(this.tokenKey, data.token);
    }
    return data;
  }

  async adminChangePassword(currentPassword, newPassword) {
    return this.fetchJson('/admin/change-password', {
      method: 'POST',
      body: JSON.stringify({
        current_password: currentPassword,
        new_password: newPassword
      })
    });
  }

  adminLogout() {
    sessionStorage.removeItem(this.tokenKey);
  }

  isAdminLoggedIn() {
    return !!sessionStorage.getItem(this.tokenKey);
  }

  async getAdminBookings() {
    return this.fetchJson('/admin/bookings');
  }

  async updateBookingStatus(id, status, notes) {
    return this.fetchJson(`/admin/bookings/${encodeURIComponent(id)}/status`, {
      method: 'PUT',
      body: JSON.stringify({ status, admin_notes: notes })
    });
  }

  async addCar(carData) {
    return this.fetchJson('/admin/cars', {
      method: 'POST',
      body: JSON.stringify(carData)
    });
  }

  async updateCar(id, carData) {
    return this.fetchJson(`/admin/cars/${encodeURIComponent(id)}`, {
      method: 'PUT',
      body: JSON.stringify(carData)
    });
  }

  async deleteCar(id) {
    return this.fetchJson(`/admin/cars/${encodeURIComponent(id)}`, {
      method: 'DELETE'
    });
  }

  async updateSettings(settingsData, locationsData) {
    return this.fetchJson('/admin/settings', {
      method: 'PUT',
      body: JSON.stringify({
        settings: settingsData,
        locations: locationsData
      })
    });
  }
}

window.api = new ApiService();
'@

$fullContent = $header + $fleetJson + $middle + $settingsJson + $middle2 + $locationsJson + $logic
[System.IO.File]::WriteAllText($apiJsPath, $fullContent, [System.Text.Encoding]::UTF8)
Write-Host "Correctly wrote js/api.js with literal template strings." -ForegroundColor Green
