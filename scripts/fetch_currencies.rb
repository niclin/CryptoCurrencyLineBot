require 'json'
require 'rest_client'

endpoint = "https://api.coinmarketcap.com/v2/listings/"
response = RestClient.get(endpoint)
response_body = JSON.parse(response)

datas = response_body["data"]

datas.each do |data|
  open('currencies.txt', "a") { |f| f << "- #{data["symbol"].downcase}\n" }
end

