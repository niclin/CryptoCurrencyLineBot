class CurrencyData::Poloniex < CurrencyData::Base
  class << self
    def price(currency, fiat_currancy = nil)
      fiat = fiat_currancy || default_fiat_currency

      begin
        response_body = get_Poloniex_ticker(currency)

        # exchange_orders = response_body["asks"]
        # puts exchange_orders
        # exchange_orders.each do |order|
        #   orders_price_total += order.first.to_d
        # end
        # puts orders_price_total

        average_price = (response_body["asks"].first.first.to_d + response_body["bids"].first.first.to_d) / 2
        average_price = average_price.to_f

        price = FiatCurrencyConverter.exchange(amount: average_price, from: default_fiat_currency, to: fiat)
        price = number_to_delimited(price)

        human_fiat_currency = fiat.upcase

        message = "[Poloniex_Price] #{price} (#{human_fiat_currency})"
      rescue
        nil
      end
    end

    private

    def default_fiat_currency
      "usdt"
    end

    def Poloniex_api_endpoint(currency)
      raise Error, "#{currency} is not supported" unless Settings.crypto_currencies.include?(currency)

      "https://poloniex.com/public?command=returnOrderBook&currencyPair=USDT_BTC&depth=1"
    end

    # Response example
    # {
    #   "asks":[["9479.00000000",0.82883196]],
    #   "bids":[["9466.04128614",0.46115265]],
    #   "isFrozen":"0","seq":234167469
    # }

    def get_Poloniex_ticker(currency)
      response = RestClient.get(Poloniex_api_endpoint(currency))

      raise Error, "APIError, response: #{response}" if response.code != 200

      JSON.parse(response)
    end
  end
end
