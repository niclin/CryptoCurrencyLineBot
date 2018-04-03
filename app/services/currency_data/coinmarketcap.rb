class CurrencyData::Coinmarketcap
  class << self
    def price(currency)
      begin
        response_body = coinmarketcap_ticker
        currency_data = get_currency_data_from_response(response_body, currency)

        rank = currency_data["rank"]
        price = currency_data["price_usd"]
        percent_change_24h = currency_data["percent_change_24h"]
        percent_change_1h = currency_data["percent_change_1h"]
        1h_chart_emoji = percent_change_1h.to_d.positive? ? "📈" : "📉"
        24h_chart_emoji = percent_change_24h.to_d.positive? ? "📈" : "📉"


        "[排名] #{rank}\n[1h漲跌 #{1h_chart_emoji}] #{percent_change_1h} %\n[24h漲跌 #{24h_chart_emoji}] #{percent_change_24h} %\n[Coinmarketcap] #{price} (USD)"
      rescue
        String.new
      end
    end

    private

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
