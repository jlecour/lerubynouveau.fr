# frozen_string_literal: true
require 'rack'
require 'rack/contrib/try_static'
require 'rack/ssl-enforcer'

# enable compression
use Rack::Deflater

# redirect to https
use Rack::SslEnforcer

# static configuration (file path matches request path)
use Rack::TryStatic,
    root: '_site',  # static files root dir
    urls: %w(/),    # match all requests
    try:  ['.html', 'index.html', '/index.html'], # try postfixes sequentially
    gzip: true, # enable compressed files
    header_rules:  [
      [:all, { 'Cache-Control' => 'public, max-age=86400' }],
      [%w(css js), { 'Cache-Control' => 'public, max-age=604800' }]
    ]

# otherwise 404 NotFound
not_found_page = File.open('_site/index.html').read
run ->(_) { [200, { 'Content-Type' => 'text/html' }, [not_found_page]] }
