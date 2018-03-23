class CurrencyData::Coinmarketcap
  class << self
    def price(currency)
      response_body = coinmarketcap_ticker
      currency_data = get_currency_data_from_response(response_body, currency)
      
      "[Coinmarketcap] #{currency_data["price_usd"]} (USD)"
    end

    private

    def coinmarketcap_api_endpoint
      "https://api.coinmarketcap.com/v1/ticker/?limit=0"
    end

    def coinmarketcap_ticker
      response = RestClient.get(coinmarketcap_api_endpoint)

      raise Error, "APIError, response: #{response}" if response.code != 200

      JSON.parse(response)
    end

    def get_currency_data_from_response(response_body, currency)
      currency_data = response_body.find { |currency_data| currency_data["symbol"] == currency.upcase }

      raise Error, "#{currency} is not supported" if currency_data.nil?

      currency_data
    end
  end
end
