require 'spec_helper'

describe Review do
  it { should belong_to(:video) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:rate) }
  it { should validate_presence_of(:content) }
end
