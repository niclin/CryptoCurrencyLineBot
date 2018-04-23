class CurrencyData::Maicoin < CurrencyData::Base
  class << self
    def price(currency, fiat_currancy = nil)
      fiat = fiat_currancy || default_fiat_currency

      begin
        raise Error, "Maicoin only support BTC" if currency != "btc"

        response_body = maicoin_ticker

        price = FiatCurrencyConverter.exchange(amount: response_body["price"].to_f.round(2), from: default_fiat_currency, to: fiat)
        sell_price = FiatCurrencyConverter.exchange(amount: response_body["sell_price"].to_f.round(2), from: default_fiat_currency, to: fiat)
        buy_price = FiatCurrencyConverter.exchange(amount: response_body["buy_price"].to_f.round(2), from: default_fiat_currency, to: fiat)

        human_fiat_currency = fiat.upcase

        message = "[Maicoin_Price] #{price} (#{human_fiat_currency})
                   [Maicoin_Sell] #{sell_price} (#{human_fiat_currency})
                   [Maicoin_Buy] #{buy_price} (#{human_fiat_currency})"

        message.delete(" ")
      rescue
        nil
      end
    end

    private

    def default_fiat_currency
      "twd"
    end

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
