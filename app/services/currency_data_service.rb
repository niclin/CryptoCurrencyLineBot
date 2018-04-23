class CurrencyDataService
  def initialize(exchange, currency, fiat_currency)
    @exchange = exchange
    @currency = currency
    @fiat_currency = fiat_currency
  end

  def get_info!
    service = "CurrencyData::#{@exchange.to_s.capitalize}".constantize
    service.price(@currency, @fiat_currency)
  end
end
