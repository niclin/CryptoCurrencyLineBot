class CurrencyData::Maicoin
  class << self
    def price(currency)
      begin
        raise Error, "Maicoin only support BTC" if currency != "btc"

        response_body = maicoin_ticker

        price = response_body["price"].to_f.round(2)
        sell_price = response_body["sell_price"].to_f.round(2)
        buy_price = response_body["buy_price"].to_f.round(2)

        "[Maicoin_Price] #{price} (TWD)\n[Maicoin_Sell] #{sell_price} (TWD)\n[Maicoin_Buy] #{buy_price} (TWD)"
      rescue
        nil
      end
    end

    private

    def maicoin_api_endpoint
      "https://api.maicoin.com/v1/prices/twd"
    end

    def maicoin_ticker
      response = RestClient.get(maicoin_api_endpoint)

      raise Error, "APIError, response: #{response}" if response.code != 200

      JSON.parse(response)
    end
  end
end
