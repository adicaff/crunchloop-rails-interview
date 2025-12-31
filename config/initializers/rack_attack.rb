# frozen_string_literal: true

module Rack
  class Attack
    # Throttle API requests by IP address
    # Allows 100 requests per 5 minutes per IP for API endpoints
    throttle('api/ip', limit: 100, period: 5.minutes) do |req|
      req.ip if req.path.start_with?('/api/')
    end

    # Throttle excessive POST, PUT, PATCH, DELETE requests
    # Allows 20 write requests per minute per IP for API endpoints
    throttle('api/write/ip', limit: 20, period: 1.minute) do |req|
      req.ip if req.path.start_with?('/api/') && %w[POST PUT PATCH DELETE].include?(req.request_method)
    end
  end
end
