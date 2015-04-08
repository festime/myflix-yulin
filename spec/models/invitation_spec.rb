require 'spec_helper'

describe Invitation do
  it { should belong_to(:sender).class_name("User") }

  it_behaves_like "tokenable" do
    let(:object) { Invitation.create }
  end
end
