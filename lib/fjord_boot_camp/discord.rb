# frozen_string_literal: true

require "net/http"

module FjordBootCamp
  class Discord
    def post(message, webhook_url)
      uri = URI.parse(webhook_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      params = { "content" => message.force_encoding('UTF-8') }
      headers = { "Content-Type" => "application/json" }
      http.post(uri.path, params.to_json, headers)
    end
  end
end
