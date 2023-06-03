require 'uri'
require 'net/http'
require 'json'

module VirginActive
  class API
    BASE_URI = uri = URI('https://api.virginactive.co.uk')

    def authenticate(username:, password:)
      uri = BASE_URI.tap { |u| u.path = '/auth/login' }

      request = Net::HTTP::Post.new(uri)
      request['Content-Type'] = 'application/json; charset=utf-8'
      request.set_form_data(
        'GrantType' => 'password',
        'Client' => 'android',
        'Scope' => 'api.virginactive.co.uk',
        'Country' => 'GB',
        'username' => username,
        'password' => password
      )

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.instance_of?(URI::HTTPS)
      response = http.request(request)

      case response
      when Net::HTTPSuccess
        @access_token = JSON.parse(response.body).fetch('token')
      else
        raise "#{response.code} #{response.message}: #{response.body}"
      end
    end

    def clubs
      uri = BASE_URI.tap { |u| u.path = '/club/clubs/details/' }

      request = Net::HTTP::Get.new(uri)
      request['Content-Type'] = 'application/json; charset=utf-8'
      request['Authorization'] = @access_token

      response = http(uri).request(request)

      case response
      when Net::HTTPSuccess
        JSON.parse(response.body).fetch('clubs')
      else
        raise "#{response.code} #{response.message}: #{response.body}"
      end
    end

    private

    def http(uri)
      Net::HTTP.new(uri.host, uri.port).tap do |http|
        http.use_ssl = true if uri.instance_of?(URI::HTTPS)
      end
    end
  end
end
