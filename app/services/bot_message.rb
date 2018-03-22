module BotMessage
  module_function

  def help
    "[指令說明]\n[BTC查詢] bot btc\n[支援幣種] bot eth/eos/qtum\n[作者] https://github.com/niclin\n[版本] v 1.0.0.beta"
  end

  def author
    "找我的主人嗎？"
  end

  def btc
    "[BTC]\n[Coinmarketcap] #{CurrencyData::Coinmarketcap.price("btc")}"
  end

  def eth
    "[ETH]\n[Coinmarketcap] #{CurrencyData::Coinmarketcap.price("eth")}"
  end
end
