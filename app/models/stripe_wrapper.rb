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

    def self.set_api_key
      Stripe.api_key = ENV["STRIPE_TEST_SECRET_KEY"]
    end
  end
end
