#!/usr/bin/env python3
"""
Simple Application Example
Deployed via Jenkins + Ansible
"""

from flask import Flask, jsonify
import os
import socket

app = Flask(__name__)

@app.route('/')
def home():
    return jsonify({
        'message': 'Hello from Jenkins + Ansible!',
        'hostname': socket.gethostname(),
        'environment': os.getenv('ENV', 'unknown')
    })

@app.route('/health')
def health():
    return jsonify({'status': 'healthy'}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
