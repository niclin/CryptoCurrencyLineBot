class LineBotResponseService
  attr_reader :reply_token

  def initialize(params)
    @params = params
    @reply_token = params['events'][0]['replyToken']
  end

  def response!
    # 拿到發話方的文字
    message_type = @params['events'][0]["message"]["type"]
    message_text = @params['events'][0]["message"]["text"]
    response_message = ""

    if message_type == "text" || message_text.start_with?("bot")
      message_text.slice!("bot ")
      key_word = message_text.strip

      return if key_word.blank?

      response_message =
      case key_word
      when "help" then BotMessage.help
      else
        "指令錯誤，輸入 bot help 瞭解完整指令。"
      end
    end

    return nil if response_message.blank?

    response_message(response_message)
  end

  private

  def response_message(message)
    {
      type: "text",
      text: message
    }
  end
end
