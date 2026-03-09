const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.json());
app.use(express.static('public'));

// Logger middleware
app.use((req, res, next) => {
    console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
    next();
});

// Home route
app.get('/', (req, res) => {
    res.json({
        message: '🐳 Welcome to Docker DevOps Lab - Node.js App',
        status: 'running',
        timestamp: new Date().toISOString(),
        version: '1.0.0',
        environment: process.env.NODE_ENV || 'development'
    });
});

// Health check endpoint
app.get('/health', (req, res) => {
    res.json({
        status: 'healthy',
        timestamp: new Date().toISOString(),
        uptime: process.uptime()
    });
});

// API endpoints
app.get('/api/info', (req, res) => {
    res.json({
        appName: 'Docker Node.js Lab',
        version: '1.0.0',
        nodejs: process.version,
        platform: process.platform,
        environment: process.env.NODE_ENV || 'development',
        port: PORT
    });
});

app.get('/api/docker-info', (req, res) => {
    res.json({
        container: 'Running in Docker',
        image: 'node:14-alpine',
        features: [
            'Express.js Framework',
            'Alpine Linux',
            'Non-root user',
            'Health check enabled',
            'JSON API'
        ],
        endpoints: [
            '/',
            '/health',
            '/api/info',
            '/api/docker-info',
            '/api/env',
            '/api/memory'
        ]
    });
});

// Environment variables (sanitized)
app.get('/api/env', (req, res) => {
    res.json({
        NODE_ENV: process.env.NODE_ENV || 'not set',
        PORT: PORT,
        APP_NAME: process.env.APP_NAME || 'Node Docker App'
    });
});

// Memory usage
app.get('/api/memory', (req, res) => {
    const memUsage = process.memoryUsage();
    res.json({
        rss: Math.round(memUsage.rss / 1024 / 1024) + ' MB',
        heapTotal: Math.round(memUsage.heapTotal / 1024 / 1024) + ' MB',
        heapUsed: Math.round(memUsage.heapUsed / 1024 / 1024) + ' MB',
        external: Math.round(memUsage.external / 1024 / 1024) + ' MB'
    });
});

// 404 handler
app.use((req, res) => {
    res.status(404).json({
        error: 'Not Found',
        message: `Route ${req.path} not found`,
        status: 404,
        availableEndpoints: [
            '/',
            '/health',
            '/api/info',
            '/api/docker-info',
            '/api/env',
            '/api/memory'
        ]
    });
});

// Error handling middleware
app.use((err, req, res, next) => {
    console.error('Error:', err);
    res.status(500).json({
        error: 'Internal Server Error',
        message: err.message,
        status: 500
    });
});

// Start server
app.listen(PORT, () => {
    console.log('========================================');
    console.log(`🚀 Node.js Application Started`);
    console.log(`📦 Running on http://localhost:${PORT}`);
    console.log(`🐳 Docker Container: Active`);
    console.log(`⏰ Started at: ${new Date().toISOString()}`);
    console.log(`🔧 Environment: ${process.env.NODE_ENV || 'development'}`);
    console.log('========================================');
    console.log('Available endpoints:');
    console.log('  GET /              - Home');
    console.log('  GET /health        - Health check');
    console.log('  GET /api/info      - App info');
    console.log('  GET /api/docker-info - Docker details');
    console.log('  GET /api/env       - Environment vars');
    console.log('  GET /api/memory    - Memory usage');
    console.log('========================================');
});

// Handle graceful shutdown
process.on('SIGTERM', () => {
    console.log('SIGTERM signal received: closing HTTP server');
    process.exit(0);
});

process.on('SIGINT', () => {
    console.log('SIGINT signal received: closing HTTP server');
    process.exit(0);
});

module.exports = app;
