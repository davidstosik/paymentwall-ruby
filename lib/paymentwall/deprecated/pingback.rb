module Paymentwall
  module Deprecated
    module Pingback
      def isSignatureValid
        Deprecated.warn_deprecated(__method__, 'valid_signature?')
        valid_signature?
      end

      def isIpAddressValid
        Deprecated.warn_deprecated(__method__, 'valid_ip_address?')
        valid_ip_address?
      end

      def isParametersValid
        Deprecated.warn_deprecated(__method__, 'valid_parameters?')
        valid_parameters?
      end

      def getType
        Deprecated.warn_deprecated(__method__, 'type')
        type
      end

      def getParameter(param)
        Deprecated.warn_deprecated(__method__, 'parameters[]')
        parameters[param]
      end

      def getUserId
        Deprecated.warn_deprecated(__method__, 'user_id')
        user_id
      end

      def getVirtualCurrencyAmount
        Deprecated.warn_deprecated(__method__, 'virtual_currency_amount')
        virtual_currency_amount
      end

      def getProductId
        Deprecated.warn_deprecated(__method__, 'product_id')
        product_id
      end

      def getProductPeriodLength
        Deprecated.warn_deprecated(__method__, 'product_period_length')
        product_period_length
      end

      def getProductPeriodType
        Deprecated.warn_deprecated(__method__, 'product_period_type')
        product_period_type
      end

      def getProduct
        Deprecated.warn_deprecated(__method__, 'product')
        product
      end

      def getProducts
        Deprecated.warn_deprecated(__method__, 'products')
        products
      end

      def getReferenceId
        Deprecated.warn_deprecated(__method__, 'reference_id')
        reference_id
      end

      def getPingbackUniqueId
        Deprecated.warn_deprecated(__method__, 'pingback_unique_id')
        pingback_unique_id
      end

      def isDeliverable
        Deprecated.warn_deprecated(__method__, 'deliverable?')
        deliverable?
      end

      def isCancelable
        Deprecated.warn_deprecated(__method__, 'cancelable?')
        cancelable?
      end

      def isUnderReview
        Deprecated.warn_deprecated(__method__, 'under_review?')
        under_review?
      end
    end
  end
end
