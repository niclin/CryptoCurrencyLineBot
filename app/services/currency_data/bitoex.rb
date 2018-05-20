class CurrencyData::Bitoex < CurrencyData::Base
  class << self
    def price(currency, fiat_currancy = nil)
      fiat = fiat_currancy || default_fiat_currency

      begin
        raise Error, "Bitoex only support BTC" if currency != "btc"

        response_body = bitoex_ticker
        sell_price = FiatCurrencyConverter.exchange(amount: response_body["sell"].to_f.round(2), from: default_fiat_currency, to: fiat)
        buy_price = FiatCurrencyConverter.exchange(amount: response_body["buy"].to_f.round(2), from: default_fiat_currency, to: fiat)

        sell_price = number_to_delimited(sell_price)
        buy_price = number_to_delimited(buy_price)

        human_fiat_currency = fiat.upcase

"[Bitoex_Sell] #{sell_price} (#{human_fiat_currency})
[Bitoex_Buy] #{buy_price} (#{human_fiat_currency})"

      rescue
        nil
      end
    end

    private

    def default_fiat_currency
      "twd"
    end

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
