class BotInstructionService
  attr_reader :first_key_word, :second_key_word

  def initialize(key_words)
    @first_key_word = key_words[0]
    @second_key_word = key_words[1]
  end

  def call!
    if only_one_instruction?
      return currency_price_info(first_key_word) if Settings.crypto_currencies.include?(first_key_word)
      return help if first_key_word == "help"
      return author if first_key_word == "nic"
    end

    if has_two_instruction?
      return currency_price_info(first_key_word, second_key_word) if Settings.crypto_currencies.include?(first_key_word) && Settings.fiat_currencies.include?(second_key_word)
    end

    return error
  end

  private

  def only_one_instruction?
    first_key_word.present? && second_key_word.blank?
  end

  def has_two_instruction?
    first_key_word.present? && second_key_word.present?
  end

  def help
"[指令說明]
[幣價查詢] bot btc
[法幣轉換] bot btc twd
[支援幣種] #{support_currencies}
[支援法幣] #{support_fiat_currencies}
[作者] niclin
[填寫建議] #{advice}
[版本] #{version}
[贊助ETH] #{donate_eth_address}
"
  end

  def advice
    "https://goo.gl/forms/dzXj5nvKqamBgXeF3"
  end

  def version
    "v1.0.0(20180423)"
  end

  def author
    "找我的主人嗎？"
  end

  def error
    "指令錯誤，輸入 bot help 瞭解完整指令。"
  end

  def donate_eth_address
    "0xC21352B20Acc6C693D4908ed7632afDF0294365f"
  end

  def currency_price_info(currency, fiat_currency = nil)
    Rails.cache.fetch("#{currency}-#{fiat_currency}-data", expires_in: 60.seconds) do
      message = "[#{currency.upcase}]\n"

      Settings.crypto_exchanges.each do |exchange|
        info = CurrencyDataService.new(exchange, currency, fiat_currency).get_info!
        message.concat("#{info}\n") if info.present?
      end

      message.chomp
    end
  end

  def support_currencies
    content = "bot "

    Settings.crypto_currencies.each do |currency|
      content.concat("#{currency}/")
    end

    content
  end

  def support_fiat_currencies
    content = "bot btc "

    Settings.fiat_currencies.each do |currency|
      content.concat("#{currency}/")
    end

    content
  end
end
