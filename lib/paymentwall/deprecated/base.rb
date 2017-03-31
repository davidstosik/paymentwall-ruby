module Paymentwall
  module Deprecated
    module Base
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def setApiType(value)
          warn "[DEPRECATION] `setApiType` is deprecated. Please use `api_type=` instead."
          self.api_type = value
          self
        end

        def getApiType
          warn "[DEPRECATION] `getApiType` is deprecated. Please use `api_type` instead."
          api_type
        end

        def setAppKey(value)
          warn "[DEPRECATION] `setAppKey` is deprecated. Please use `app_key=` instead."
          self.app_key = value
          self
        end

        def getAppKey
          warn "[DEPRECATION] `getAppKey` is deprecated. Please use `app_key` instead."
          app_key
        end

        def setSecretKey(value)
          warn "[DEPRECATION] `setSecretKey` is deprecated. Please use `secret_key=` instead."
          self.secret_key = value
          self
        end

        def getSecretKey
          warn "[DEPRECATION] `getSecretKey` is deprecated. Please use `secret_key` instead."
          secret_key
        end
      end
    end
  end
end
