module StripeWrapper
  class Charge
    attr_reader :response, :status

    def initialize(response, status)
      @response = response
      @status = status
    end

    def self.create(options = {})
      begin
        response = Stripe::Charge.create(amount: options[:amount],
                                         currency: "usd",
                                         source: options[:source],
                                         description: "Sign up charge for #{options[:email]}")
        new(response, :success)
      rescue Stripe::CardError => e
        new(e, :error)
      end
    end

    def successful?
      status == :success
    end

    def error_message
      response.message
    end
  end

  class Customer
    attr_reader :status, :error_message

    def initialize(status, exception = nil)
      @status = status
      @error_message = exception.message if exception.respond_to? :message
    end

    def self.create(options)
      begin
        customer = Stripe::Customer.create(
          :source => options[:source],
          :plan => "basic",
          :email => "#{options[:email]}",
          :description => "Subscripttion of '#{options[:name]}'"
        )
        new(:success)
      rescue Stripe::CardError => e
        new(:failure, e)
      end
    end

    def successful?
      (status == :success ? true : false)
    end
  end
end
