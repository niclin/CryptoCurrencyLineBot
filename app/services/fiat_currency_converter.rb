class FiatCurrencyConverter
  class << self
    def exchange(amount:, from:, to:)
      if from == "usdt"
        to = "usd" if to == "usdt"
        from_currency = Money::Currency.new("usd")
        rate = Money.new(usdt_to_usd_rate, from_currency).exchange_to(to).to_d * from_currency.subunit_to_unit
      else
        from_currency = Money::Currency.new(from)
        rate = Money.new(1, from_currency).exchange_to(to).to_d * from_currency.subunit_to_unit
      end

      (amount.to_d * rate).round(2)
    end

    private

    def usdt_to_usd_rate
      Rails.cache.fetch("#{Time.zone.today}-usdt-rate") do
        response = RestClient.get("https://api.coinmarketcap.com/v1/ticker/?limit=0")

        raise Error, "APIError, response: #{response}" if response.code != 200
        response_body = JSON.parse(response)

        currency_data = response_body.find { |currency_data| currency_data["symbol"] == "USDT" }

        currency_data["price_usd"].to_f
      end
    end
  end
end
