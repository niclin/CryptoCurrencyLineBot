class CurrencyData::Okcoin < CurrencyData::Base
  class << self
    def price(currency, fiat_currancy)
      fiat = fiat_currancy || default_fiat_currency

      begin
        response_body = get_okcoin_ticker(currency)
        average_price = (response_body["ticker"]["buy"].to_d + response_body["ticker"]["sell"].to_d) / 2
        average_price = average_price.to_f

        price = FiatCurrencyConverter.exchange(amount: average_price, from: default_fiat_currency, to: fiat)
        price = number_to_delimited(price)

        human_fiat_currency = fiat.upcase

        message = "[Okcoin_Price] #{price} (#{human_fiat_currency})"
      rescue
        nil
      end
    end

    private

    def default_fiat_currency
      "usd"
    end

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
