module BotMessage
  module_function

  def help
    "[ 指令說明 ]\n[ BTC查詢 ] bot btc\n[ 支援幣種 ] bot eth/eos/qtum\n[ 作者 ] https://github.com/niclin"
  end

  def author
    "找我的主人嗎？"
  end

  # TODO: 把呼叫 currency 額外整理成一個 class

  def btc
    response_body = coinmarketcap_ticker
    currency_data = get_currency_data_from_response(response_body, "btc")
    "#{currency_data["price_usd"]} USD"
  end

  def eth
    response_body = coinmarketcap_ticker
    currency_data = get_currency_data_from_response(response_body, "eth")
    "#{currency_data["price_usd"]} USD"
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
