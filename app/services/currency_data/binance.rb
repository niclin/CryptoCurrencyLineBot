class CurrencyData::Binance < CurrencyData::Base
  class << self
    def price(currency, fiat_currancy = nil)
      fiat = fiat_currancy || default_fiat_currency

      begin
        response_body = binance_ticker
        ticker = response_body.select { |ticker| ticker["symbol"] == "#{currency.upcase}USDT" }.first
        average_price = ticker["price"].to_f.round(2)

        price = FiatCurrencyConverter.exchange(amount: average_price, from: default_fiat_currency, to: fiat)

        human_fiat_currency = fiat.upcase

        "[Binance_Price] #{price} (#{human_fiat_currency})"
      rescue
        nil
      end
    end

    private

    def default_fiat_currency
      "usdt"
    end

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
