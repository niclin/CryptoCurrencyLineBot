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

    return if message_type == "text" || !message_text.start_with?("bot")

    response_message(type, message)
  end

  private

  def response_message(type, message)
    {
      type: type,
      text: "指令輸入對了"
    }
  end
end
