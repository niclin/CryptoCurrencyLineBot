class LineBotResponseService
  attr_reader :reply_token, :message

  def initialize(params)
    @params = params
    @reply_token = params['events'][0]['replyToken']
  end

  def call!
    # 拿到發話方的文字
    message_type = @params['events'][0]["message"]["type"]
    message_text = @params['events'][0]["message"]["text"]

    # 設定回覆訊息
    @message = {
      type: message_type,
      text: "您說的是 「#{message_text}」 嗎？"
    }
  end
end
