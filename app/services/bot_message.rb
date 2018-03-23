module BotMessage
  module_function

  def help
    "[指令說明]\n[BTC查詢] bot btc\n#{support_currencies}\n[作者] https://github.com/niclin\n[版本] v 1.0.0.beta"
  end

  def support_currencies
    title = "[支援幣種]"
    content = "bot "

    Settings.crypto_currencies.each do |currency|
      content.concat("#{currency}/")
    end

    "#{title} #{content}"
  end

  def author
    "找我的主人嗎？"
  end

  def currency_price_info(currency)
    currency_name = currency.upcase
    coinmarketcap = CurrencyData::Coinmarketcap.price(currency)
    maicoin = CurrencyData::Maicoin.price(currency)
    bitoex = CurrencyData::Bitoex.price(currency)

    "[#{currency_name}]\n#{coinmarketcap}\n#{maicoin}\n{bitoex}"
  end
end
