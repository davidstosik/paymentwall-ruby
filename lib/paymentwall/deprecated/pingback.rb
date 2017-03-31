module Paymentwall
  module Deprecated
    module Pingback
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.extend(ClassMethods)
      end

      module InstanceMethods
        def isSignatureValid
          warn "[DEPRECATION] `isSignatureValid` is deprecated. Please use `valid_signature?` instead."
          valid_signature?
        end

        def isIpAddressValid
          warn "[DEPRECATION] `isIpAddressValid` is deprecated. Please use `valid_ip_address?` instead."
          valid_ip_address?
        end

        def isParametersValid
          warn "[DEPRECATION] `isParametersValid` is deprecated. Please use `valid_parameters?` instead."
          valid_parameters?
        end

        def getType
          warn "[DEPRECATION] `getType` is deprecated. Please use `type` instead."
          type
        end

        def getParameter(param)
          warn "[DEPRECATION] `getParameter` is deprecated. Please use `parameters[]` instead."
          parameters[param]
        end

        def getUserId
          warn "[DEPRECATION] `getUserId` is deprecated. Please use `user_id` instead."
          user_id
        end

        def getVirtualCurrencyAmount
          warn "[DEPRECATION] `getVirtualCurrencyAmount` is deprecated. Please use `virtual_currency_amount` instead."
          virtual_currency_amount
        end

        def getProductId
          warn "[DEPRECATION] `getProductId` is deprecated. Please use `product_id` instead."
          product_id
        end

        def getProductPeriodLength
          warn "[DEPRECATION] `getProductPeriodLength` is deprecated. Please use `product_period_length` instead."
          product_period_length
        end

        def getProductPeriodType
          warn "[DEPRECATION] `getProductPeriodType` is deprecated. Please use `product_period_type` instead."
          product_period_type
        end

        def getProduct
          warn "[DEPRECATION] `getProduct` is deprecated. Please use `product` instead."
          product
        end

        def getProducts
          warn "[DEPRECATION] `getProducts` is deprecated. Please use `products` instead."
          products
        end

        def getReferenceId
          warn "[DEPRECATION] `getReferenceId` is deprecated. Please use `reference_id` instead."
          reference_id
        end

        def getPingbackUniqueId
          warn "[DEPRECATION] `getPingbackUniqueId` is deprecated. Please use `pingback_unique_id` instead."
          pingback_unique_id
        end

        def isDeliverable
          warn "[DEPRECATION] `isDeliverable` is deprecated. Please use `deliverable?` instead."
          deliverable?
        end

        def isCancelable
          warn "[DEPRECATION] `isCancelable` is deprecated. Please use `cancelable?` instead."
          cancelable?
        end

        def isUnderReview
          warn "[DEPRECATION] `isUnderReview` is deprecated. Please use `under_review?` instead."
          under_review?
        end
      end

      module ClassMethods
      end
    end
  end
end
