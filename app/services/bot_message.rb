module BotMessage
  module_function

  def help
    "[指令說明]\n[BTC查詢] bot btc\n[支援幣種] bot eth/eos/qtum\n[作者] https://github.com/niclin\n[版本] v 1.0.0.beta"
  end

  def author
    "找我的主人嗎？"
  end

  def currency_price_info(currency)
    currency_name = currency.upcase
    coinmarketcap = CurrencyData::Coinmarketcap.price(currency)
    maicoin = CurrencyData::Maicoin.price(currency)
    bitoex = CurrencyData::Bitoex.price(currency)

    "#{currency_name}\n#{coinmarketcap}\n#{maicoin}\n{bitoex}"
  end
end
