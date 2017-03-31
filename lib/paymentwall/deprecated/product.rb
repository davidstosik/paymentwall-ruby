module Paymentwall
  module Deprecated
    module Product
      def getId
        Deprecated.warn_deprecated(__method__, 'id')
        id
      end

      def getAmount
        Deprecated.warn_deprecated(__method__, 'amount')
        amount
      end

      def getCurrencyCode
        Deprecated.warn_deprecated(__method__, 'currency_code')
        currency_code
      end

      def getName
        Deprecated.warn_deprecated(__method__, 'name')
        name
      end

      def getType
        Deprecated.warn_deprecated(__method__, 'type')
        type
      end

      def getPeriodType
        Deprecated.warn_deprecated(__method__, 'period_type')
        period_type
      end

      def getPeriodLength
        Deprecated.warn_deprecated(__method__, 'period_length')
        period_length
      end

      def isRecurring
        Deprecated.warn_deprecated(__method__, 'recurring?')
        recurring?
      end

      def getTrialProduct
        Deprecated.warn_deprecated(__method__, 'trial_product')
        trial_product
      end
    end
  end
end
