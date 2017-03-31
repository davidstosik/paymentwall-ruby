module Paymentwall
  module Deprecated
    module Base
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def setApiType(value)
          Deprecated.warn_deprecated(__method__, 'api_type=')
          self.api_type = value
          self
        end

        def getApiType
          Deprecated.warn_deprecated(__method__, 'api_type')
          api_type
        end

        def setAppKey(value)
          Deprecated.warn_deprecated(__method__, 'app_key=')
          self.app_key = value
          self
        end

        def getAppKey
          Deprecated.warn_deprecated(__method__, 'app_key')
          app_key
        end

        def setSecretKey(value)
          Deprecated.warn_deprecated(__method__, 'secret_key=')
          self.secret_key = value
          self
        end

        def getSecretKey
          Deprecated.warn_deprecated(__method__, 'secret_key')
          secret_key
        end
      end
    end
  end
end
