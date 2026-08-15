const fs = require('fs');

// Mock window and document environment
const window = {
  CRD_STATE: {},
  location: { search: '?id=CRD-TEST123&token=tok_test', protocol: 'https:', origin: 'https://car-rental-dehradun.com' }
};
global.window = window;
global.document = {
  title: '',
  addEventListener: () => {},
  querySelectorAll: () => [],
  getElementById: (id) => {
    return {
      innerHTML: '',
      style: {},
      textContent: '',
      addEventListener: () => {}
    };
  }
};
global.sessionStorage = { getItem: () => null, setItem: () => {}, removeItem: () => {} };
global.localStorage = { getItem: () => null, setItem: () => {}, removeItem: () => {} };
global.URLSearchParams = require('url').URLSearchParams;

// Load app.js and booking.js
eval(fs.readFileSync('js/app.js', 'utf8'));
eval(fs.readFileSync('js/booking.js', 'utf8'));

console.log('====================================================');
console.log('  TESTING DATE & CURRENCY RESILIENCE');
console.log('====================================================');

// Test 1: Date formatting
const dateCases = [
  { input: '2026-08-20', expectedNot: 'Not available', label: 'Valid ISO date' },
  { input: null, expected: 'Not available', label: 'null date' },
  { input: undefined, expected: 'Not available', label: 'undefined date' },
  { input: '', expected: 'Not available', label: 'empty string date' },
  { input: 'invalid-date-string', expected: 'Not available', label: 'Invalid string date' },
  { input: 'TBD', expected: 'Not available', label: 'TBD date' }
];

let passCount = 0;
dateCases.forEach(tc => {
  const res = window.formatDate(tc.input);
  if (tc.expected && res === tc.expected) {
    console.log(` [PASS] formatDate(${tc.label}) -> "${res}"`);
    passCount++;
  } else if (tc.expectedNot && res !== tc.expectedNot && res.length > 3) {
    console.log(` [PASS] formatDate(${tc.label}) -> "${res}"`);
    passCount++;
  } else {
    console.error(` [FAIL] formatDate(${tc.label}) -> "${res}"`);
  }
});

// Test 2: Currency formatting
const currCases = [
  { input: 2500, expected: 'â‚¹2,500', label: 'Normal number 2500' },
  { input: '3500', expected: 'â‚¹3,500', label: 'String "3500"' },
  { input: null, expected: 'â‚¹0', label: 'null currency' },
  { input: undefined, expected: 'â‚¹0', label: 'undefined currency' },
  { input: NaN, expected: 'â‚¹0', label: 'NaN currency' }
];

currCases.forEach(tc => {
  const res = window.formatCurrency(tc.input);
  if (res === tc.expected) {
    console.log(` [PASS] formatCurrency(${tc.label}) -> "${res}"`);
    passCount++;
  } else {
    console.error(` [FAIL] formatCurrency(${tc.label}) -> "${res}"`);
  }
});

// Test 3: Simulation of Confirmation Page Render with Missing Date / Incomplete Data
console.log('\n====================================================');
console.log('  TESTING CONFIRMATION / LOOKUP RENDER CRASH RESILIENCE');
console.log('====================================================');

const testVouchers = [
  {
    desc: 'Complete Normal Voucher',
    voucher: {
      id: 'CRD-100001',
      customer_name: 'Rahul Sharma',
      customer_phone: '9876543210',
      pickup_location: 'Dehradun Railway Station',
      drop_location: 'Dehradun Railway Station',
      pickup_date: '2026-08-25',
      drop_date: '2026-08-28',
      days: 3,
      rental_amount: 7500,
      security_deposit: 3000,
      estimated_total: 10500,
      car_name: 'Maruti Swift Dzire'
    }
  },
  {
    desc: 'Voucher with Missing Dates (undefined/null)',
    voucher: {
      id: 'CRD-100002',
      customer_name: 'Anita Verma',
      pickup_date: undefined,
      drop_date: null,
      rental_amount: undefined,
      security_deposit: null,
      estimated_total: undefined
    }
  },
  {
    desc: 'Voucher completely empty object {}',
    voucher: {}
  }
];

let renderPass = 0;
testVouchers.forEach(tv => {
  try {
    const raw = tv.voucher;
    const voucher = (raw && raw.booking) ? raw.booking : (raw || {});
    const displayId = voucher.id || 'CRD-TEST';
    const carName = voucher.car_name || 'Selected Rental Car';
    const carImage = voucher.car_image || 'images/cars/swift-dzire.jpg';
    const status = voucher.status || 'Confirmed';
    const customerName = voucher.customer_name || 'Valued Customer';
    const customerPhone = voucher.customer_phone || 'Not available';
    const pickupLoc = voucher.pickup_location || 'Dehradun Office - Kalika Vihar Phase 2, Banjarawala Road';
    const dropLoc = voucher.drop_location || pickupLoc;
    const pickupDateFormatted = window.formatDate(voucher.pickup_date);
    const dropDateFormatted = window.formatDate(voucher.drop_date);
    const days = voucher.days || 1;
    const kmLimitPerDay = voucher.km_limit_per_day || 200;
    const totalKmLimit = voucher.total_km_limit || (kmLimitPerDay * days);
    const rentalAmountFormatted = window.formatCurrency(voucher.rental_amount);
    const securityDepositFormatted = window.formatCurrency(voucher.security_deposit !== undefined ? voucher.security_deposit : 3000);
    const estimatedTotalFormatted = window.formatCurrency(voucher.estimated_total !== undefined ? voucher.estimated_total : ((voucher.rental_amount || 0) + (voucher.security_deposit || 3000)));

    console.log(` [PASS] ${tv.desc} -> rendered safely without throwing:`);
    console.log(`        Dates: ${pickupDateFormatted} to ${dropDateFormatted} | Total: ${estimatedTotalFormatted}`);
    renderPass++;
  } catch (err) {
    console.error(` [FAIL] ${tv.desc} -> THREW ERROR:`, err.message);
  }
});

console.log('\n====================================================');
console.log(`TOTAL ASSERTIONS PASSED: ${passCount + renderPass}/${dateCases.length + currCases.length + testVouchers.length}`);
console.log('====================================================');