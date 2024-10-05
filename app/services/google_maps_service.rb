require 'net/http'
require 'json'

class GoogleMapsService
  BASE_URL = 'https://maps.googleapis.com/maps/api/geocode/json'

  def self.fetch_lat_long(address, api_key)
    url = URI("#{BASE_URL}?address=#{URI.encode(address)}&key=#{api_key}")
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
  end
end
