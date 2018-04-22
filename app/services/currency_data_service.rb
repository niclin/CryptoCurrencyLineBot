class CurrencyDataService
  def initialize(exchange, currency)
    @exchange = exchange
    @currency = currency
  end

  def get_info!
    service = "CurrencyData::#{@exchange.to_s.capitalize}".constantize
    service.price(@currency)
  end
end
