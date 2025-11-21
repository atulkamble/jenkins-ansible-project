#!/usr/bin/env python3
"""
Simple Application Example
Deployed via Jenkins + Ansible
"""

from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import socket
import os
from datetime import datetime

class RequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/':
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            response = {
                'status': 'success',
                'message': 'Hello from Jenkins + Ansible! 🚀',
                'hostname': socket.gethostname(),
                'environment': os.getenv('ENV', 'local'),
                'timestamp': datetime.now().isoformat(),
                'deployed_by': 'Ansible',
                'version': '1.0.0'
            }
            self.wfile.write(json.dumps(response, indent=2).encode())
        elif self.path == '/health':
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            response = {'status': 'healthy', 'timestamp': datetime.now().isoformat()}
            self.wfile.write(json.dumps(response, indent=2).encode())
        else:
            self.send_response(404)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            response = {'error': 'Not found'}
            self.wfile.write(json.dumps(response).encode())
    
    def log_message(self, format, *args):
        print(f"{datetime.now().isoformat()} - {format % args}")

if __name__ == '__main__':
    port = 8080
    server = HTTPServer(('0.0.0.0', port), RequestHandler)
    print(f'✅ Server started on http://localhost:{port}')
    print(f'📊 Access endpoints:')
    print(f'   - http://localhost:{port}/')
    print(f'   - http://localhost:{port}/health')
    print(f'🛑 Press Ctrl+C to stop')
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print('\n🛑 Server stopped')
