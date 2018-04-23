class CurrencyData::Bitoex < CurrencyData::Base
  class << self
    def price(currency, fiat_currancy)
      fiat_currency = fiat_currancy || default_fiat_currency

      begin
        raise Error, "Bitoex only support BTC" if currency != "btc"

        response_body = bitoex_ticker
        sell_price = FiatCurrencyConverter.exchange(amount: response_body["sell"].to_f.round(2), from: default_fiat_currency, to: fiat_currancy)
        buy_price = FiatCurrencyConverter.exchange(amount: response_body["buy"].to_f.round(2), from: default_fiat_currency, to: fiat_currancy)

        human_fiat_currency = fiat_currancy.upcase

        message = "[Bitoex_Sell]#{sell_price} (#{human_fiat_currency})
                   [Bitoex_Buy]#{buy_price} (#{human_fiat_currency})"

        message.delete(" ")
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
