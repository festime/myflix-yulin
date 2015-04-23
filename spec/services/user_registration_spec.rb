require 'spec_helper'

describe UserRegistration do
  context "with valid personal info and valid card" do
    let(:user) { Fabricate.build(:user) }

    before do
      #charge = double('charge', successful?: true)
      #expect(StripeWrapper::Charge).to receive(:create).and_return(charge)
      result = double('result', successful?: true)
      expect(StripeWrapper::Customer).to receive(:create).and_return(result)
    end

    after { ActionMailer::Base.deliveries.clear }

    it "creates a user" do
      UserRegistration.new(user, nil, "valid stripe token").call
      expect(User.count).to eq(1)
    end

    context "sending emails" do
      after { ActionMailer::Base.deliveries.clear }
      before do
        UserRegistration.new(user, nil, "valid stripe token").call
      end

      it "sends an email to the new user" do
        expect(ActionMailer::Base.deliveries.last.to).to eq([user.email])
      end

      it "contains the right content" do
        expect(ActionMailer::Base.deliveries.last.body).to include("Welcome to MyFlix, #{user.name}")
      end
    end

    context "with valid invitation token" do
      let(:addressee) { Fabricate.build(:user) }
      let(:sender) { Fabricate(:user) }
      let(:invitation) { Fabricate(:invitation, sender: sender) }

      before do
        UserRegistration.new(addressee, invitation.token, "valid stripe token").call
        addressee.reload
      end

      it "makes the addresse follow the sender" do
        expect(addressee.following?(sender)).to be_truthy
      end

      it "makes the sender follow the addresse" do
        expect(sender.following?(addressee)).to be_truthy
      end

      it "deletes the invitation in database" do
        expect(Invitation.count).to eq(0)
      end
    end

    context "with invalid invitation token" do
      let(:addressee) { Fabricate.build(:user) }

      it "does not establish any relationships" do
        UserRegistration.new(addressee, nil, "valid stripe token").call
        expect(Relationship.count).to eq(0)
      end
    end
  end

  context "with valid personal info and declined card" do
    let(:user) { Fabricate.build(:user) }

    before do
      charge = double('charge', successful?: false, error_message: "The card was declined.")
      StripeWrapper::Charge.stub(:create).and_return(charge)
      UserRegistration.new(user, nil, "invalid stripe token")
    end

    it "does not save @user" do
      expect(User.count).to eq(0)
    end

    it "does not send an email" do
      expect(ActionMailer::Base.deliveries).to be_empty
    end

    it "does not charge the credit card" do
      expect(StripeWrapper::Charge).to_not receive(:create)
    end
  end

  context "with invalid personal info and valid card" do
    let(:user) { Fabricate.build(:user, name: "") }

    before do
      charge = double('charge', successful?: true)
      StripeWrapper::Charge.stub(:create).and_return(charge)
      UserRegistration.new(user, nil, "valid stripe token")
    end

    it "does not save @user" do
      expect(User.count).to eq(0)
    end

    it "does not send an email" do
      expect(ActionMailer::Base.deliveries).to be_empty
    end

    it "does not charge the credit card" do
      expect(StripeWrapper::Charge).to_not receive(:create)
    end
  end
end
