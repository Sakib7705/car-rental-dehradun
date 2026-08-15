/**
 * Car Rental Dehradun - Service Worker
 * Provides safe offline asset caching while excluding private admin data & booking APIs.
 */

const CACHE_NAME = 'crd-static-v1.0.0';

const STATIC_ASSETS = [
  '/',
  '/index.html',
  '/cars.html',
  '/car-details.html',
  '/book.html',
  '/confirmation.html',
  '/about.html',
  '/contact.html',
  '/terms.html',
  '/privacy.html',
  '/cancellation.html',
  '/faq.html',
  '/css/style.css',
  '/css/components.css',
  '/js/api.js',
  '/js/app.js',
  '/js/booking.js',
  '/js/pwa.js',
  '/manifest.webmanifest',
  '/images/icons/icon-192.png',
  '/images/icons/icon-512.png'
];

// Install Event - Pre-cache static shell
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll(STATIC_ASSETS).catch((err) => {
        console.warn('Some static assets failed to pre-cache:', err);
      });
    }).then(() => self.skipWaiting())
  );
});

// Activate Event - Clean old caches
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) => {
      return Promise.all(
        keys.map((key) => {
          if (key !== CACHE_NAME) {
            return caches.delete(key);
          }
        })
      );
    }).then(() => self.clients.claim())
  );
});

// Fetch Event - Safe Strategy
self.addEventListener('fetch', (event) => {
  const url = new URL(event.request.url);

  // CRITICAL SECURITY RULE: NEVER cache private admin pages or booking mutation APIs
  if (
    url.pathname.includes('/admin') ||
    url.pathname.startsWith('/api/admin') ||
    (url.pathname.startsWith('/api/bookings') && event.request.method === 'POST') ||
    url.pathname.startsWith('/api/bookings/voucher')
  ) {
    // Pass straight to network without caching
    return event.respondWith(fetch(event.request));
  }

  // Network-first for public API reads with fallback
  if (url.pathname.startsWith('/api/')) {
    event.respondWith(
      fetch(event.request)
        .then((response) => {
          // Cache successful public API GETs
          if (response.ok && event.request.method === 'GET') {
            const clone = response.clone();
            caches.open(CACHE_NAME).then((cache) => cache.put(event.request, clone));
          }
          return response;
        })
        .catch(() => caches.match(event.request))
    );
    return;
  }

  // Cache-first for static assets
  event.respondWith(
    caches.match(event.request).then((cached) => {
      if (cached) return cached;

      return fetch(event.request).then((response) => {
        if (
          response &&
          response.status === 200 &&
          response.type === 'basic' &&
          !url.pathname.includes('/admin')
        ) {
          const responseToCache = response.clone();
          caches.open(CACHE_NAME).then((cache) => {
            cache.put(event.request, responseToCache);
          });
        }
        return response;
      }).catch(() => {
        // If offline and requesting an HTML page, return index.html cache
        if (event.request.headers.get('accept')?.includes('text/html')) {
          return caches.match('/index.html');
        }
      });
    })
  );
});
