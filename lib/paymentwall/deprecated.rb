module Paymentwall
  module Deprecated
    def self.warn_deprecated(method, alternative)
      warn "[DEPRECATION] `#{method}` is deprecated. Please use `#{alternative}` instead."
    end
  end
end
