require 'net/http'
require 'json'
require 'cgi' # Certifique-se de carregar a biblioteca CGI

class GoogleMapsService
  BASE_URL = 'https://maps.googleapis.com/maps/api/geocode/json'

  def self.fetch_lat_long(address, api_key)
    encoded_address = CGI.escape(address) # Substitui URI.encode
    url = URI("#{BASE_URL}?address=#{encoded_address}&key=#{api_key}")
    response = Net::HTTP.get(url)
    result = JSON.parse(response)

    if result['status'] == 'OK'
      {
        latitude: result['results'].first['geometry']['location']['lat'],
        longitude: result['results'].first['geometry']['location']['lng']
      }
    else
      { error: result['status'] }
    end
  rescue StandardError => e
    { error: e.message }
  end
end
