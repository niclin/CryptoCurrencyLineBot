class CurrencyData::Bitoex
  class << self
    def price(currency)
      begin
        raise Error, "Bitoex only support BTC" if currency != "btc"

        response_body = bitoex_ticker
        sell_price = response_body["sell"].round(2)
        buy_price = response_body["buy"].round(2)

        message = "[Bitoex_Sell]#{sell_price} (TWD)
                   [Bitoex_Buy]#{buy_price} (TWD)"

        message.delete(" ")
      rescue
        nil
      end
    end

    private

    def bitoex_api_endpoint
      "https://www.bitoex.com/api/v1/get_rate"
    end

    def bitoex_ticker
      response = RestClient.get(bitoex_api_endpoint)

      raise Error, "APIError, response: #{response}" if response.code != 200

      JSON.parse(response)
    end
  end
end
