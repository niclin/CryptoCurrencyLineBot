class CurrencyData::Coinmarketcap < CurrencyData::Base
  class << self
    def price(currency, fiat_currancy)
      fiat_currency = fiat_currancy || default_fiat_currency

      begin
        response_body = coinmarketcap_ticker
        currency_data = get_currency_data_from_response(response_body, currency)

        rank = currency_data["rank"]

        percent_change_24h = currency_data["percent_change_24h"]
        percent_change_1h = currency_data["percent_change_1h"]

        chart_emoji_1h = percent_change_1h.to_d.positive? ? "📈" : "📉"
        chart_emoji_24h = percent_change_24h.to_d.positive? ? "📈" : "📉"

        price = FiatCurrencyConverter.exchange(amount: currency_data["price_usd"].to_f, from: default_fiat_currency, to: fiat_currancy)

        human_fiat_currency = fiat_currancy.upcase

        message = "[排名] #{rank}
                   [1h漲跌 #{chart_emoji_1h}] #{percent_change_1h} %
                   [24h漲跌 #{chart_emoji_24h}] #{percent_change_24h} %
                   [Coinmarketcap] #{price} (#{human_fiat_currency})"

        message.delete(" ")
      rescue
        nil
      end
    end

    private

    def default_fiat_currency
      "usd"
    end

    def coinmarketcap_api_endpoint
      "https://api.coinmarketcap.com/v1/ticker/?limit=0"
    end

    def coinmarketcap_ticker
      response = RestClient.get(coinmarketcap_api_endpoint)

      raise Error, "APIError, response: #{response}" if response.code != 200

      JSON.parse(response)
    end

    def get_currency_data_from_response(response_body, currency)
      currency_data = response_body.find { |currency_data| currency_data["symbol"] == currency.upcase }

      raise Error, "#{currency} is not supported" if currency_data.nil?

      currency_data
    end
  end
end
