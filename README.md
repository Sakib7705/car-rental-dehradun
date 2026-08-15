# Car Rental Dehradun - Production Web App & PWA

A high-performance, mobile-first Car Rental Booking web application and Progressive Web App (PWA) built for **Car Rental Dehradun** (`https://car-rental-dehradun.com`), phone / WhatsApp `+91 8923665501`.

---

## 1. Project Structure

```
d:\Car-rental-dehradun.com\
├── data/
│   └── database.json           # Persistent database (cars, bookings, admin credentials, settings)
├── css/
│   ├── style.css               # Core design system tokens, typography, header, hero & footer
│   ├── components.css          # Search widget, car cards, sticky mobile bar, vouchers, dialogs
│   └── admin.css               # Admin portal styles, data tables, metrics cards, status badges
├── js/
│   ├── api.js                  # Frontend API client with offline detection & real-time validation
│   ├── app.js                  # Global UI interactions, mobile nav drawer, toast system, FAQ
│   ├── booking.js              # Booking engine, dynamic date overlap check, WhatsApp message builder
│   ├── admin.js                # Secure Admin SPA logic, session guard, password reset, CRUD
│   └── pwa.js                  # PWA service worker registration, custom install prompt
├── images/
│   ├── cars/                   # High-res car graphics for all 10 fleet models + interior views
│   └── icons/                  # PWA application icons (192px, 512px)
├── index.html                  # Homepage (Hero, Live Search Widget, Featured Fleet, FAQ, Schema)
├── cars.html                   # Fleet Listing with category filters & dynamic price sorting
├── car-details.html            # Car Details (Photo gallery, specs, 200 KM limit, live availability)
├── book.html                   # Dedicated Booking Page with multi-step validation
├── confirmation.html           # Booking Confirmation Voucher with Booking ID & WhatsApp CTA
├── about.html                  # About Us & Dehradun / Uttarakhand Service Coverage
├── contact.html                # Contact Us, direct phone/WhatsApp, inquiry form
├── terms.html                  # Rental Terms, 200 KM policy & required documents (Aadhaar / DL)
├── privacy.html                # Privacy Policy & Customer Data Protection
├── cancellation.html           # Cancellation & Refund Policy
├── faq.html                    # FAQ with interactive accordions & FAQPage JSON-LD schema
├── admin/
│   ├── index.html              # Admin Dashboard (Analytics KPIs & Recent Bookings)
│   ├── login.html              # Secure Admin Login with session token storage
│   ├── cars.html               # Fleet Manager (Add/Edit cars, customize daily price, daily KM limit)
│   ├── bookings.html           # Bookings Manager (Filter by status, search, detail modal, voucher print)
│   └── settings.html           # Business Settings (KM limit, extra KM rate, deposit, contacts)
├── manifest.webmanifest        # PWA Web App Manifest (standalone display, shortcuts, theme)
├── sw.js                       # Service Worker for offline asset caching (excludes admin/bookings)
├── sitemap.xml                 # SEO XML Sitemap
├── robots.txt                  # Robots directives (excludes /admin/)
├── server.js                   # Production Node.js REST API & static server
├── server.ps1                  # Native Windows PowerShell / .NET HttpListener REST API server
├── generate_assets.ps1         # Asset generator script
└── README.md                   # Complete documentation
```

---

## 2. Technology Stack

- **Frontend**: Semantic HTML5, Vanilla CSS3 (Custom Design System with CSS variables and responsive tokens), Vanilla JavaScript (ES6+ modular architecture).
- **Backend / API**:
  - `server.js`: Lightweight, zero-dependency Node.js HTTP & REST API server.
  - `server.ps1`: Native Windows PowerShell /.NET HttpListener REST server (runs on any Windows machine out of the box with zero external installs).
- **Database**: Persistent JSON database engine (`data/database.json`) with atomic file writes, PBKDF2/SHA-256 password hashing, and session management.
- **PWA**: Service Worker (`sw.js`) with cache-first static shell strategy and Web App Manifest (`manifest.webmanifest`).
- **SEO**: Schema.org JSON-LD structured data (`AutoRental`, `LocalBusiness`, `FAQPage`), OpenGraph metadata, XML sitemap, and robots.txt.

---

## 3. Database Structure

`data/database.json` contains:
- `settings`: Business name, phone, WhatsApp, email, default 200 KM limit, extra KM fee, default security deposit, seasonal pricing multiplier.
- `locations`: Active service locations in Dehradun, Mussoorie, Rishikesh, Haridwar, and Uttarakhand.
- `cars`: 10 catalogue vehicles with individual pricing, KM limits, specs, and descriptions.
- `bookings`: Active and historical customer reservations with unique booking IDs and verification tokens.
- `admin`: Admin username, hashed password, salt, and `must_change_password` flag.
- `sessions`: Ephemeral token sessions with expiration timestamps.

---

## 4. Admin Login Setup & First-Time Security

1. Open your browser and navigate to: `http://localhost:3000/admin/login.html` (or `https://car-rental-dehradun.com/admin/login.html`).
2. Default initial development credentials:
   - **Username:** `admin`
   - **Password:** `admin123`
3. **Mandatory Security Step**:
   - On your first login, the security system prompts you to change your password immediately.
   - Enter a new strong password (minimum 8 characters).
   - Once updated, the system generates a cryptographic salt, computes the SHA-256/PBKDF2 hash, and saves it into `data/database.json`.

---

## 5. How to Add / Edit Cars & Change Prices

1. Log in to the Admin Dashboard (`admin/index.html`) and click **Fleet & Pricing** (`admin/cars.html`).
2. **To Change Price / Daily KM Limit of an Existing Car**:
   - Click **Edit Price & Specs** next to any car (e.g. Maruti Swift Dzire).
   - Update **Rental Price / Day (₹)** (e.g. change ₹1,800 to your current rate).
   - Update **Daily KM Limit** (default: 200 KM), **Extra KM Charge** (₹12/km), or **Security Deposit** (₹3,000).
   - Click **Save Vehicle**. The new price immediately reflects across the website and booking calculator.
3. **To Add a New Car**:
   - Click **➕ Add New Vehicle**.
   - Enter model name, category, fuel type, transmission, seating capacity, price per day, KM limit, and photo path.
   - Click **Save Vehicle**.

---

## 6. How to Manage Bookings

1. Navigate to **Bookings** (`admin/bookings.html`).
2. Filter bookings by status: `New`, `Pending`, `Confirmed`, `Completed`, or `Cancelled`.
3. Search by Customer Name, Mobile Number, or Booking ID.
4. Click **Manage** to view the customer's full trip details, pickup/drop location, and travel dates.
5. Update the booking status from `New` to `Confirmed` when the car is dispatched.
6. Click the **💬 WhatsApp** icon next to any booking to directly open a WhatsApp chat with the customer.

---

## 7. How to Configure WhatsApp & Phone Numbers

1. Log in to Admin and click **Business Settings** (`admin/settings.html`).
2. Update **Business Phone** and **WhatsApp Number** (Default: `8923665501`).
3. Click **Save Configuration Changes**.
4. All dynamic WhatsApp booking links, call buttons, and header buttons across the website update automatically.

---

## 8. How to Run the App Locally

### Option A: Using Native Windows PowerShell (Zero Setup)
Open PowerShell in the project directory:
```powershell
powershell -ExecutionPolicy Bypass -File server.ps1
```
The server will start at `http://localhost:3000/`.

### Option B: Using Node.js
If Node.js is installed on your system:
```bash
node server.js
```
The server will start at `http://localhost:3000/`.

---

## 9. How to Deploy Publicly

### VPS / Cloud Server (Ubuntu / Debian / AlmaLinux)
1. Copy the project files to your server (e.g. `/var/www/car-rental-dehradun`).
2. Install Node.js: `sudo apt update && sudo apt install nodejs npm -y`
3. Install PM2 process manager: `sudo npm install -g pm2`
4. Start the app:
   ```bash
   pm2 start server.js --name "car-rental-dehradun"
   pm2 save
   pm2 startup
   ```

---

## 10. How to Connect `car-rental-dehradun.com` (Domain & SSL)

### DNS Configuration
In your domain registrar (GoDaddy, Namecheap, Cloudflare, etc.), create:
- **A Record**: `@` → `YOUR_SERVER_IP`
- **CNAME Record**: `www` → `car-rental-dehradun.com`

### Nginx Reverse Proxy Setup
Create `/etc/nginx/sites-available/car-rental-dehradun.conf`:
```nginx
server {
    server_name car-rental-dehradun.com www.car-rental-dehradun.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```
Enable site and restart Nginx:
```bash
sudo ln -s /etc/nginx/sites-available/car-rental-dehradun.conf /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
```

### Free SSL with Let's Encrypt Certbot
```bash
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d car-rental-dehradun.com -d www.car-rental-dehradun.com
```

---

## 11. How to Install PWA on Android & iOS

- **Android (Chrome, Edge, Samsung Internet)**:
  - Visit `https://car-rental-dehradun.com`.
  - An in-app "Install Car Rental App" banner will appear at the bottom.
  - Tap **Install** or tap the 3-dot menu and select **Install App** / **Add to Home Screen**.
- **iOS / iPhone (Safari)**:
  - Open `https://car-rental-dehradun.com` in Safari.
  - Tap the **Share** button (box with arrow pointing up).
  - Scroll and tap **Add to Home Screen**.

---

## 12. Production Configuration Checklist

- [x] Initial admin password changed from default.
- [x] WhatsApp number verified (`+91 8923665501`).
- [x] Daily prices adjusted for all 10 catalogue vehicles.
- [x] 200 KM daily limit and extra KM fees configured.
- [x] SSL certificate installed and HTTPS active.
- [x] Sitemap submitted to Google Search Console (`https://car-rental-dehradun.com/sitemap.xml`).
