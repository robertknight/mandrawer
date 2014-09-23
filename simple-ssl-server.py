#!/usr/bin/env python3

from http.server import HTTPServer,SimpleHTTPRequestHandler
from socketserver import BaseServer

import argparse
import ssl

parser = argparse.ArgumentParser(description="""Serve a local directory
 via SSL.

 An SSL certificate is required, see
 http://www.akadia.com/services/ssh_test_certificate.html for
 instructions to generate a private key and
 suitable self-signed SSL cert.
""")
parser.add_argument('keyfile', type=str, action='store')
parser.add_argument('certfile', type=str, action='store')
parser.add_argument('port', type=int, action='store', default=8000)
args = parser.parse_args()

httpd = HTTPServer(('', args.port), SimpleHTTPRequestHandler)
httpd.socket = ssl.wrap_socket (httpd.socket, keyfile=args.keyfile, certfile=args.certfile, server_side=True)
httpd.serve_forever()
