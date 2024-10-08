require 'net/http'
require 'json'
require 'cgi'

class GoogleMapsService
  GEOCODE_BASE_URL = 'https://maps.googleapis.com/maps/api/geocode/json'
  AUTOCOMPLETE_BASE_URL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json'

  def self.fetch_lat_long(address, api_key)
    encoded_address = CGI.escape(address) # Substitui URI.encode
    url = URI("#{GEOCODE_BASE_URL}?address=#{encoded_address}&key=#{api_key}")
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

  def self.fetch_address_suggestions(address_fragment, api_key)
    encoded_address = CGI.escape(address_fragment)
    url = URI("#{AUTOCOMPLETE_BASE_URL}?input=#{encoded_address}&components=country:BR&key=#{api_key}")
    
    response = Net::HTTP.get(url)
    result = JSON.parse(response)
  
    if result['status'] == 'OK'
      # Retorna uma lista de sugestões de endereços
      suggestions = result['predictions'].map { |r| r['description'] }
      { suggestions: suggestions }
    else
      { error: result['status'] }
    end
  end
end
