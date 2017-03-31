module Paymentwall
  module Deprecated
    module Errors
      def getErrors
        warn "[DEPRECATION] `getErrors` is deprecated. Please use `errors` instead."
        errors
      end

      def getErrorSummary
        warn "[DEPRECATION] `getErrorSummary` is deprecated. Please use `error_summary` instead."
        error_summary
      end
    end
  end
end
