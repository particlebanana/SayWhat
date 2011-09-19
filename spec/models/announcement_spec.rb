require 'spec_helper'

describe Announcement do
  before { @announcement = Announcement.create( { title: "Test", text: "Test Announcement" } ) }
  
  subject { @announcement }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:text) }
end