class CryptoCurrenciesController < ApplicationController
  protect_from_forgery with: :null_session
  
  def webhook
    head :ok
  end
end
