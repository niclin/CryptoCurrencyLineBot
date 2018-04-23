module FiatCurrencyData
  class GoogleRate
    def initialize(from:, to:)
      @from = from
      @to = to
    end

    def fetch!
      from_currency = Money::Currency.new(@from)
      rate = Money.new(1, from_currency).exchange_to(@to).to_d * from_currency.subunit_to_unit
    end
  end
end
