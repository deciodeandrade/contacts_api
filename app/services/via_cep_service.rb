require 'net/http'
require 'json'

class ViaCepService
  BASE_URL = 'https://viacep.com.br/ws'

  def self.fetch_address(cep)
    url = URI("#{BASE_URL}/#{cep}/json/")
    response = Net::HTTP.get(url)
    JSON.parse(response)
  rescue StandardError => e
    { error: e.message }
  end
end
