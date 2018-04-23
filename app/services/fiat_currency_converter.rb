class FiatCurrencyConverter
  class << self
    def exchange(amount:, from:, to:)
      from_currency = Money::Currency.new(from)
      rate = Money.new(1, from_currency).exchange_to(to).to_d * from_currency.subunit_to_unit

      amount.to_d * rate
    end
  end
end
