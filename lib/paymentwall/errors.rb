module Paymentwall
  module Errors
    def errors
      @errors ||= []
    end

    def error_summary
      errors.join("\n")
    end

    def self.included(base)
      base.include(Deprecated::Errors)
    end
  end
end
