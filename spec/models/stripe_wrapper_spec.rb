require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge, :vcr do
    context "with valid card" do
      let(:card_number) { "4242424242424242" }

      it "charges the card successfully" do
        token = Stripe::Token.create(
          :card => {
            :number => "#{card_number}",
            :exp_month => 4,
            :exp_year => 2018,
            :cvc => "314"
          },
        ).id

        charge = StripeWrapper::Charge.create(
          amount: '999',
          source: token,
          email: Faker::Internet.email
        )
        expect(charge).to be_successful
        expect(charge.response.amount).to eq(999)
        expect(charge.response.currency).to eq('usd')
      end
    end

    context "with invalid card" do
      let(:card_number) { "4000000000000002" }
      let(:token) do
        Stripe::Token.create(
          :card => {
            :number => "#{card_number}",
            :exp_month => 4,
            :exp_year => 2018,
            :cvc => "314"
          },
        ).id
      end

      it "charges the card unsuccessfully" do
        charge = StripeWrapper::Charge.create(amount: '999', source: token, email: Faker::Internet.email)
        expect(charge).to_not be_successful
      end

      it "sets an error message" do
        charge = StripeWrapper::Charge.create(amount: '999', source: token, email: Faker::Internet.email)
        expect(charge.error_message).to eq("Your card was declined.")
      end
    end
  end
end
