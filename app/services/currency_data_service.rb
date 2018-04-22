class CurrencyDataService

  def initialize(exchange, currency)
    @exchange = exchange
    @currency = currency
  end

  def get_info!
    case @exchange
    when "binance"
      CurrencyData::Binance.price(@currency)
    when "bitoex"
      CurrencyData::Bitoex.price(@currency)
    when "coinmarketcap"
      CurrencyData::Coinmarketcap.price(@currency)
    when "huobi"
      CurrencyData::Huobi.price(@currency)
    when "maicoin"
      CurrencyData::Maicoin.price(@currency)
    when "okcoin"
      CurrencyData::Okcoin.price(@currency)
    end
  end
end
