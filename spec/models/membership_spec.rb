require 'spec_helper'

describe Membership do
  before { @membership = Membership.new() }
  
  context "Factory" do
    subject { @membership }
    it { should belong_to(:user) }
    it { should belong_to(:group) }
  end
end