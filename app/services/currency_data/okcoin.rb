class CurrencyData::Okcoin
  class << self

    def price(currency)
      begin
        response_body = get_okcoin_ticker(currency)
        average_price = (response_body["ticker"]["buy"].to_d + response_body["ticker"]["sell"].to_d) / 2

        "[Okcoin_Price] #{average_price} (USD)"
      rescue
        nil
      end
    end

    private

    def okcoin_api_endpoint(currency)
      raise Error, "#{currency} is not supported" unless Settings.crypto_currencies.include?(currency)

      "https://www.okcoin.com/api/v1/ticker.do?symbol=#{currency}_usd"
    end

    # Response example
    # {
    #   "date":"1511776804",
    #   "ticker":{"high":"9800.00",
    #   "vol":"580.17",
    #   "last":"9573.91",
    #   "low":"8890.78",
    #   "buy":"9535.02",
    #   "sell":"9576.70"}
    # }
    def get_okcoin_ticker(currency)
      response = RestClient.get(okcoin_api_endpoint(currency))

      raise Error, "APIError, response: #{response}" if response.code != 200

      JSON.parse(response)
    end
  end
end
