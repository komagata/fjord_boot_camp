# frozen_string_literal: true

require "net/http"
require "json"

module FjordBootCamp
  class Client
    AUTH_API_URL = "https://bootcamp.fjord.jp/api/session"
    COUNT_API_URL = "https://bootcamp.fjord.jp/api/admin/count.json"
    UNASSIGNED_PRODUCT_API_URL = "https://bootcamp.fjord.jp/api/products/unassigned/counts.txt"
    UNCHECKED_REPORTS_API_URL = "https://bootcamp.fjord.jp/api/reports/unchecked/counts.txt"

    attr_accessor :token

    def authenticate(login_name, password)
      response = Net::HTTP.post_form(
        URI.parse(AUTH_API_URL),
        login_name: login_name,
        password: password
      )
      @token = JSON.parse(response.body)["token"]
    end

    def users_count
      uri = URI.parse(COUNT_API_URL)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      headers = {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{@token}"
      }
      response = http.get(uri.path, headers)
      JSON.parse(response.body)["users_count"]
    end

    def unassigned_products
      fetch_plain_text(UNASSIGNED_PRODUCT_API_URL)
    end

    def unchecked_reports
      fetch_plain_text(UNCHECKED_REPORTS_API_URL)
    end

    private

    def fetch_plain_text(url)
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      headers = {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{@token}"
      }
      response = http.get(uri.path, headers)
      response.body.force_encoding('UTF-8')
    end
  end
end
