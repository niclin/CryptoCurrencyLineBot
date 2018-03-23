class LineBotResponseService
  attr_reader :reply_token

  def initialize(params)
    @params = params
    @reply_token = params['events'][0]['replyToken']

    # 拿到發話方的文字
    @message_type = params['events'][0]["message"]["type"].downcase
    @message_text = params['events'][0]["message"]["text"].downcase
  end

  def response!
    response_message = ""

    if trigger_response?
      key_word = @message_text.delete(" ").gsub('bot', '')
      response_message = response_by_key_word(key_word) if key_word.present?
    end

    return nil if response_message.blank?

    response_message(response_message)
  end

  private

  def trigger_response?
    @message_type == "text" && @message_text.start_with?("bot")
  end

  def response_message(message)
    {
      type: "text",
      text: message
    }
  end

  def response_by_key_word(key_word)
    return BotMessage.currency_price_info(key_word) if Settings.crypto_currencies.include?("key_word")
    return BotMessage.help if key_word == "help"
    return BotMessage.author if key_word == "nic"
    return "指令錯誤，輸入 bot help 瞭解完整指令。" 
  end
end
