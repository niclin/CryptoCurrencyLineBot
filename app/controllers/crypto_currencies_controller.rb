require 'line/bot'

class CryptoCurrenciesController < ApplicationController
  protect_from_forgery with: :null_session

  def webhook
    # Line Bot API 物件初始化
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV['line_channel_secret']
      config.channel_token = ENV['line_channel_token']
    }
    
    # 取得 reply token
    reply_token = params['events'][0]['replyToken']

    # 設定回覆訊息
    message = {
      type: 'text',
      text: '好哦～好哦～'
    }

    # 傳送訊息
    response = client.reply_message(reply_token, message)
      
    # 回應 200
    head :ok
  end
end
