class CurrencyData::Binance
  class << self

    def price(currency)
      begin
        response_body = binance_ticker
        ticker = response_body.select { |ticker| ticker["symbol"] == "#{currency.upcase}USDT" }.first
        average_price = ticker["price"]

        "[Binance_Price] #{average_price} (USDT)"
      rescue
        nil
      end
    end

    private

    def binance_api_endpoint
      "https://www.binance.com/api/v1/ticker/allPrices"
    end

    def binance_ticker
      response = RestClient.get(binance_api_endpoint)

      raise Error, "APIError, response: #{response}" if response.code != 200

      JSON.parse(response)
    end
  end
end