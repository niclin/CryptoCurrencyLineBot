module BotMessage
  module_function

  def help
    message = "[指令說明]
               [BTC查詢] bot btc
               [支援幣種] #{support_currencies}
               [作者] https://github.com/niclin
               [填寫建議] #{advice}
               [版本] #{version}
              "
    message.delete(" ")
  end

  def advice
    "https://goo.gl/forms/dzXj5nvKqamBgXeF3"
  end

  def version
    "v1.0.0.beta"
  end

  def support_currencies
    content = "bot "

    Settings.crypto_currencies.each do |currency|
      content.concat("#{currency}/")
    end

    content
  end

  def author
    "找我的主人嗎？"
  end

  def currency_price_info(currency)
    Rails.cache.fetch("#{currency}-data", expires_in: 60.seconds) do
      message = "[#{currency.upcase}]"

      Settings.crypto_exchanges.each do |exchange|
        service = CurrencyData.new(exchange, currency)
        info = service.get_info!
        message.concat("#{info}\n") if info.present?
      end

      message
    end
  end

  def error
    "指令錯誤，輸入 bot help 瞭解完整指令。"
  end
end
