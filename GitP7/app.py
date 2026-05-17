from flask import Flask, jsonify
import os

app = Flask(__name__)

# Environment variables
APP_VERSION = os.getenv('APP_VERSION', '1.0.0')
ENVIRONMENT = os.getenv('FLASK_ENV', 'production')

@app.route('/')
def home():
    """Home endpoint"""
    return jsonify({
        'message': 'Welcome to Docker CI/CD Pipeline!',
        'version': APP_VERSION,
        'environment': ENVIRONMENT
    })

@app.route('/health')
def health():
    """Health check endpoint"""
    return jsonify({
        'status': 'healthy',
        'version': APP_VERSION
    }), 200

@app.route('/api/info')
def info():
    """Application info endpoint"""
    return jsonify({
        'app': 'Docker CI/CD Demo',
        'version': APP_VERSION,
        'environment': ENVIRONMENT,
        'docker': 'enabled'
    })

if __name__ == '__main__':
    print(f"Starting application v{APP_VERSION} in {ENVIRONMENT} mode")
    app.run(host='0.0.0.0', port=5000, debug=(ENVIRONMENT == 'development'))
