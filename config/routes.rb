Rails.application.routes.draw do
  post '/crypto_currency/webhook', to: 'crypto_currencies#webhook'
end
