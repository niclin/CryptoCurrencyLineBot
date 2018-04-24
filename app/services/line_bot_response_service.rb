class LineBotResponseService
  attr_reader :reply_token

  def initialize(params)
    @params = params
    @reply_token = params['events'][0]['replyToken']

    @message_type = params['events'][0]["message"]["type"].downcase
    @message_text = params['events'][0]["message"]["text"].downcase

    @source_type = params['events'][0]['source']['type'].downcase
    @source_group_token = params['events'][0]['source']['groupId']
  end

  def response!
    record_group!

    message = ""

    if trigger_response?
      key_words = @message_text.remove("bot").strip.split(' ')
      message = response_by_key_word(key_words) if key_words.present?
    end

    return nil if message.blank?

    response_message(message)
  end

  private

  def record_group!
    Group.find_or_create_by(token: @source_group_token) if @source_type == "group"
  end

  def trigger_response?
    @message_type == "text" && @message_text.start_with?("bot")
  end

  def response_message(message)
    {
      type: "text",
      text: message
    }
  end

  def response_by_key_word(key_words)
    BotInstructionService.new(key_words).call!
  end
end
