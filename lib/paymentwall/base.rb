module Paymentwall
  class Base
    include Errors
    include Paymentwall::Deprecated::Base

    VERSION = '1.0.0'

    API_VC = 1
    API_GOODS = 2
    API_CART = 3

    CONTROLLER_PAYMENT_VIRTUAL_CURRENCY = 'ps'
    CONTROLLER_PAYMENT_DIGITAL_GOODS = 'subscription'
    CONTROLLER_PAYMENT_CART = 'cart'

    DEFAULT_SIGNATURE_VERSION = 3
    SIGNATURE_VERSION_1 = 1
    SIGNATURE_VERSION_2 = 2
    SIGNATURE_VERSION_3 = 3

    class << self
      attr_accessor :api_type, :app_key, :secret_key
    end
  end
end
