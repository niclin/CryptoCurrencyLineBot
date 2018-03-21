require 'line/bot'

class CryptoCurrenciesController < ApplicationController
  protect_from_forgery with: :null_session

  def webhook
    # Line Bot API 物件初始化
    client = Line::Bot::Client.new { |config|
      config.channel_secret = '9160ce4f0be51cc72c3c8a14119f567a'
      config.channel_token = '2ncMtCFECjdTVmopb/QSD1PhqM6ECR4xEqC9uwIzELIsQb+I4wa/s3pZ4BH8hCWeqfkpVGVig/mIPDsMjVcyVbN/WNeTTw5eHEA7hFhaxPmQSY2Cud51LKPPiXY+nUi+QrXy0d7Hi2YUs65B/tVOpgdB04t89/1O/w1cDnyilFU='
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
