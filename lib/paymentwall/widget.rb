require 'uri'
require 'digest'

module Paymentwall
  class Widget < Paymentwall::Base
    include Deprecated::Widget

    BASE_URL = 'https://api.paymentwall.com/api'

    def initialize(user_id, widget_code, products = [], extra_params = {})
      @user_id = user_id
      @widget_code = widget_code
      @extra_params = extra_params
      @products = products
    end

    def signature_version
      if Base::api_type == Base::API_CART
        Base::DEFAULT_SIGNATURE_VERSION
      else
        Base::SIGNATURE_VERSION_2
      end
    end

    def url
      params = {
        'key' => Base::app_key,
        'uid' => @user_id,
        'widget' => @widget_code
      }

      products_number = @products.count

      case Base::api_type
      when Base::API_GOODS

        if @products.kind_of?(Array)

          if products_number == 1
            product = @products[0]
            if product.kind_of?(Paymentwall::Product)

              post_trial_product = nil
              if product.getTrialProduct.kind_of?(Paymentwall::Product)
                 post_trial_product = product
                 product = product.getTrialProduct
              end

              params['amount'] = product.getAmount
              params['currencyCode'] = product.getCurrencyCode
              params['ag_name'] = product.getName
              params['ag_external_id'] = product.getId
              params['ag_type'] = product.getType

              if product.getType == Paymentwall::Product::TYPE_SUBSCRIPTION
                params['ag_period_length'] = product.getPeriodLength
                params['ag_period_type'] = product.getPeriodType
                if product.isRecurring

                  params['ag_recurring'] = product.isRecurring ? 1 : 0

                  if post_trial_product
                    params['ag_trial'] = 1
                    params['ag_post_trial_external_id'] = post_trial_product.getId
                    params['ag_post_trial_period_length'] = post_trial_product.getPeriodLength
                    params['ag_post_trial_period_type'] = post_trial_product.getPeriodType
                    params['ag_post_trial_name'] = post_trial_product.getName
                    params['post_trial_amount'] = post_trial_product.getAmount
                    params['post_trial_currencyCode'] = post_trial_product.getCurrencyCode
                  end
                end
              end
            else
              #TODO: errors << 'Not an instance of Paymentwall::Product'
            end
          else
            #TODO: errors << 'Only 1 product is allowed in flexible widget call'
          end

        end

      when Base::API_CART
        index = 0
        @products.each do |product|
          params['external_ids[' + index.to_s + ']'] = product.getId

          if product.getAmount() > 0
            params['prices[' + index.to_s + ']'] = product.getAmount
          end
          if product.getCurrencyCode != '' && product.getCurrencyCode != nil
            params['currencies[' + index.to_s + ']'] = product.getCurrencyCode
          end
          index += 1
        end
      end

      params['sign_version'] = local_signature_version = signature_version

      if @extra_params.include?('sign_version')
        local_signature_version = params['sign_version'] = @extra_params['sign_version']
      end

      params = params.merge(@extra_params)

      params['sign'] = self.class.calculate_signature(params, Base::secret_key, local_signature_version)

      "#{BASE_URL}/#{build_controller(@widget_code)}?#{http_build_query(params)}"
    end

    def html(attributes = {})
      default_attributes = {
        'frameborder' => '0',
        'width' => '750',
        'height' => '800'
      }

      attributes = default_attributes.merge(attributes)

      attributes_query = attributes.map do |attr, value|
        %( #{attr}="#{value}")
      end.join

      %(<iframe src="#{url}" #{attributes_query}></iframe>)
    end

    def self.calculate_signature(params, secret, version)
      base_string = ''
      if version == Base::SIGNATURE_VERSION_1
        # TODO: throw exception if no uid parameter is present

        base_string += params.include?('uid') ? params['uid'] : ''
        base_string += secret

        Digest::MD5.hexdigest(base_string)
      else
        params.keys.each do |name|
          p = params[name]

          # converting array to hash
          if p.kind_of?(Array)
            p = Hash[p.map.with_index { |key, value| [value, key] }]
          end

          if p.kind_of?(Hash)
            sub_keys = p.keys.sort
            sub_keys.each do |key|
              value = p[key]
              base_string += "#{name}[#{key}]=#{value}"
            end
          else
            base_string += "#{name}=#{p}"
          end
        end

        base_string += secret

        if version == Base::SIGNATURE_VERSION_3
          Digest::SHA256.hexdigest(base_string)
        else
          Digest::MD5.hexdigest(base_string)
        end
      end
    end

    private

    def build_controller(widget, flexible_call = false)
      case Base::api_type
      when Base::API_VC
        if !/^w|s|mw/.match(widget)
          return Base::CONTROLLER_PAYMENT_VIRTUAL_CURRENCY
        end
      when Base::API_GOODS
        if !flexible_call
          if !/^w|s|mw/.match(widget)
            return Base::CONTROLLER_PAYMENT_DIGITAL_GOODS
          end
        else
          return Base::CONTROLLER_PAYMENT_DIGITAL_GOODS
        end
      else
        return Base::CONTROLLER_PAYMENT_CART
      end
    end

    def http_build_query(params)
      params.map do |key, value|
        "#{key}=#{url_encode(value)}"
      end.join('&')
    end

    def url_encode(value)
      URI.escape(value.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end
  end
end
