module Paymentwall
  module Deprecated
    module Errors
      def getErrors
        Deprecated.warn_deprecated(__method__, 'errors')
        errors
      end

      def getErrorSummary
        Deprecated.warn_deprecated(__method__, 'error_summary')
        error_summary
      end
    end
  end
end
