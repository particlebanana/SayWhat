require 'spec_helper'

describe ProjectPhoto do
  before do
    @group = Factory.create(:group)
    @project = Factory.create(:project, { group: @group } )
    @project.photos.new({ project: @project, photo: 'test' })
    @project.save!
  end

  context "Validations" do
    subject { @project.photos.first }
    it { should belong_to(:project) }
    it { should validate_presence_of(:photo) }
  end
end