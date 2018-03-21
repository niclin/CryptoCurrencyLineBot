Rails.application.routes.draw do
  post '/crypto_currencies/webhook', to: 'crypto_currencies#webhook'
end
