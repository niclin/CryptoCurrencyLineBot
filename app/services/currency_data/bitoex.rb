class CurrencyData::Bitoex
  class << self
    def price(currency)
      begin
        raise Error, "Bitoex only support BTC" if currency != "btc"

        response_body = bitoex_ticker

        "[Bitoex_Sell]#{response_body["sell"]} (TWD)\n[Bitoex_Buy]#{response_body["buy"]} (TWD)"
      rescue
        String.new
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