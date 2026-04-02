/**
 * Entry point for CloudLinux/Hostinger Passenger
 */

// Disable WebAssembly for performance/memory reasons on shared hosting
process.env.NODE_OPTIONS = (process.env.NODE_OPTIONS || '') + ' --no-wasm';
process.env.UNDICI_WASM = '0';
process.env.UNDICI_DISABLE_WASM = 'true';

// Set production environment
process.env.NODE_ENV = 'production';

// Heap memory limits for V8
try {
  const v8 = require('v8');
  v8.setFlagsFromString('--max_old_space_size=512');
  v8.setFlagsFromString('--optimize_for_size');
  v8.setFlagsFromString('--memory_reducer');
} catch (err) {
  console.log('V8 limits adjustment skipped:', err.message);
}

// Minimal error handling for Passenger logs
process.on('uncaughtException', (err) => {
  console.error('CRITICAL: Uncaught Exception:', err);
});

process.on('unhandledRejection', (reason) => {
  console.error('CRITICAL: Unhandled Rejection:', reason);
});

console.log('🚀 Starting CdelU API for Hostinger...');

// Load the main application
try {
  require('./src/index.js');
  console.log('✅ Main application loaded successfully');
} catch (error) {
  console.error('❌ Failed to load main application:', error.message);
  
  // Fallback to minimal index if available
  try {
    require('./src/index.minimal.js');
    console.log('✅ Fallback minimal application loaded');
  } catch (err) {
    console.error('💥 Fatal error loading any application:', err.message);
    process.exit(1);
  }
}
