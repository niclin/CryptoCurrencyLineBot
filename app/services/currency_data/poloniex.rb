class CurrencyData::Poloniex < CurrencyData::Base
  class << self
    def price(currency, fiat_currancy = nil)
      fiat = fiat_currancy || default_fiat_currency

        response_body = get_poloniex_ticker

        average_price = response_body["#{default_fiat_currency.upcase}_#{currency.upcase}"]["last"]
        average_price = average_price.to_f

        price = FiatCurrencyConverter.exchange(amount: average_price, from: default_fiat_currency, to: fiat)
        price = number_to_delimited(price)

        human_fiat_currency = fiat.upcase

        message = "[Poloniex_Price] #{price} (#{human_fiat_currency})"

    end

    private

    def default_fiat_currency
      "usdt"
    end

    def poloniex_api_endpoint
      "https://poloniex.com/public?command=returnTicker"
    end

    def get_poloniex_ticker
      response = RestClient.get(poloniex_api_endpoint)

      raise Error, "APIError, response: #{response}" if response.code != 200
      JSON.parse(response)
    end
  end
end
