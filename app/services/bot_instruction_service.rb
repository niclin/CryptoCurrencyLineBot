class BotInstructionService

  def initialize(key_word)
    @key_word = key_word
  end

  def call!
    return BotMessage.currency_price_info(@key_word) if Settings.crypto_currencies.include?(@key_word)
    return BotMessage.help if @key_word == "help"
    return BotMessage.author if @key_word == "nic"
    return BotMessage.error
  end
end
