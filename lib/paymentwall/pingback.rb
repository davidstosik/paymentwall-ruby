module Paymentwall
  class Pingback < Paymentwall::Base
    include Deprecated::Pingback

    PINGBACK_TYPE_REGULAR = 0
    PINGBACK_TYPE_GOODWILL = 1
    PINGBACK_TYPE_NEGATIVE = 2
    PINGBACK_TYPE_RISK_UNDER_REVIEW = 200
    PINGBACK_TYPE_RISK_REVIEWED_ACCEPTED = 201
    PINGBACK_TYPE_RISK_REVIEWED_DECLINED = 202

    IP_WHITELIST = [
      '174.36.92.186',
      '174.36.96.66',
      '174.36.92.187',
      '174.36.92.192',
      '174.37.14.28'
    ].freeze

    attr_accessor :parameters

    def initialize(parameters = {}, ip_address = '')
      super()
      @parameters = parameters
      @ip_address = ip_address
    end

    def validate(skip_ip_whitelist_check = false)
      validated = false

      if valid_parameters?
        if valid_ip_address? || skip_ip_whitelist_check
          if valid_signature?
            validated = true
          else
            errors << 'Wrong signature'
          end
        else
          errors << 'IP address is not whitelisted'
        end
      else
        errors << 'Missing parameters'
      end

      validated
    end

    def valid_signature?
      signature_params_to_sign = {}

      signature_params = case Base::api_type.to_i
      when Base::API_VC
        %w(uid currency type ref)
      when Base::API_GOODS
        %w(uid goodsid slength speriod type ref)
      else
        %w(uid goodsid type ref)
      end

      if !@parameters.include?('sign_version') || @parameters['sign_version'].to_i == Base::SIGNATURE_VERSION_1
        signature_params.each do |field|
          signature_params_to_sign[field] = @parameters.include?(field) ? @parameters[field] : nil
        end

        @parameters['sign_version'] = Base::SIGNATURE_VERSION_1
      else
        signature_params_to_sign  = @parameters
      end

      signature_calculated = calculate_signature(signature_params_to_sign, Base::secret_key, @parameters['sign_version'])

      @parameters['sig'] == signature_calculated
    end

    def valid_ip_address?
      IP_WHITELIST.include? @ip_address
    end

    def valid_parameters?
      errors_number = 0
      required_params = []

      case Base::api_type.to_i
      when Base::API_VC
        required_params = ['uid', 'currency', 'type', 'ref', 'sig']
      when Base::API_GOODS
        required_params = ['uid', 'goodsid', 'type', 'ref', 'sig']
      else
        required_params = ['uid', 'goodsid', 'type', 'ref', 'sig']
      end

      required_params.each do |field|
        if !@parameters.include?(field)
          errors << "Parameter #{field} is missing"
          errors_number += 1
        end
      end

      errors_number == 0
    end

    def type
      pingbackTypes = [
        PINGBACK_TYPE_REGULAR,
        PINGBACK_TYPE_GOODWILL,
        PINGBACK_TYPE_NEGATIVE,
        PINGBACK_TYPE_RISK_UNDER_REVIEW,
        PINGBACK_TYPE_RISK_REVIEWED_ACCEPTED,
        PINGBACK_TYPE_RISK_REVIEWED_DECLINED
      ]

      if @parameters.include?('type')
        if pingbackTypes.include?(@parameters['type'].to_i)
          @parameters['type'].to_i
        end
      end
    end

    def user_id
      parameters['uid'].to_s
    end

    def virtual_currency_amount
      parameters['currency'].to_i
    end

    def product_id
      parameters['goodsid'].to_s
    end

    def product_period_length
      parameters['slength'].to_i
    end

    def product_period_type
      parameters['speriod'].to_s
    end

    def product
      Product.new(
        self.product_id,
        0,
        nil,
        nil,
        product_period_length > 0 ? Product::TYPE_SUBSCRIPTION : Product::TYPE_FIXED,
        product_period_length,
        product_period_type
      )
    end

    def products
      result = []
      product_ids = parameters['goodsid']

      if product_ids.kind_of?(Array)
        product_ids.each do |id|
          result.push(Product.new(id))
        end
      end

      result
    end

    def reference_id
      parameters['ref'].to_s
    end

    def pingback_unique_id
      "#{reference_id}_#{type}"
    end

    def deliverable?
      [
        PINGBACK_TYPE_REGULAR,
        PINGBACK_TYPE_GOODWILL,
        PINGBACK_TYPE_RISK_REVIEWED_ACCEPTED
      ].include?(type)
    end

    def cancelable?
      [
        PINGBACK_TYPE_NEGATIVE,
        PINGBACK_TYPE_RISK_REVIEWED_DECLINED
      ].include?(type)
    end

    def under_review?
      type == PINGBACK_TYPE_RISK_UNDER_REVIEW
    end

    private

    def calculate_signature(params, secret, version)
      params = params.clone
      params.delete('sig')

      sort_keys = (version.to_i == Base::SIGNATURE_VERSION_2 or version.to_i == Base::SIGNATURE_VERSION_3)
      keys = sort_keys ? params.keys.sort : params.keys

      base_string = ''

      keys.each do |name|
        p = params[name]

        # converting array to hash
        if p.kind_of?(Array)
          p = Hash[p.map.with_index { |key, value| [value, key] }]
        end

        if p.kind_of?(Hash)
          sub_keys = sort_keys ? p.keys.sort : p.keys;
          sub_keys.each do |key|
            value = p[key]
            base_string += "#{name}[#{key}]=#{value}"
          end
        else
          base_string += "#{name}=#{p}"
        end
      end

      base_string += secret

      require 'digest'
      if version.to_i == Base::SIGNATURE_VERSION_3
        Digest::SHA256.hexdigest(base_string)
      else
        Digest::MD5.hexdigest(base_string)
      end
    end

    def signature_version
      @parameters['sign_version'] ||= Base::SIGNATURE_VERSION_1
      @parameters['sign_version'].to_i
    end

    def signature_params
      case Base::api_type
      when Base::API_VC
        %w(uid currency type ref)
      when Base::API_GOODS
        %w(uid goodsid slength speriod type ref)
      else
        %w(uid goodsid type ref)
      end
    end
  end
end
