module Paymentwall
  module Deprecated
    module Widget
      def getDefaultSignatureVersion
        Deprecated.warn_deprecated(__method__, 'signature_version')
        signature_version
      end

      def getUrl
        Deprecated.warn_deprecated(__method__, 'url')
        url
      end

      def getHtmlCode(*args)
        Deprecated.warn_deprecated(__method__, 'html')
        url
      end

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def calculateSignature(*args)
          Deprecated.warn_deprecated(__method__, 'calculate_signature')
          calculate_signature(*args)
        end
      end
    end
  end
end
