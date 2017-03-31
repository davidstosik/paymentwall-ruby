module Paymentwall
  class Product
    include Deprecated::Product

    TYPE_SUBSCRIPTION = 'subscription'
    TYPE_FIXED = 'fixed'

    PERIOD_TYPE_DAY = 'day'
    PERIOD_TYPE_WEEK = 'week'
    PERIOD_TYPE_MONTH = 'month'
    PERIOD_TYPE_YEAR = 'year'

    def initialize(id, amount = 0.0, currency_code = nil, name = nil, type = TYPE_FIXED, period_length = 0, period_type = nil, recurring = false, trial_product = nil)
      @id = id
      @amount = amount.round(2)
      @currency_code = currency_code
      @name = name
      @type = type
      @period_length = period_length
      @period_type = period_type
      @recurring = recurring && recurring != 0
      if type == TYPE_SUBSCRIPTION && recurring?
        @trial_product = trial_product
      end
    end

    attr_reader :product_id, :amount, :currency_code, :name, :type, :period_type, :period_length, :trial_product

    def recurring?
      !!@recurring
    end
  end
end
