require File.expand_path("../../spec_helper", __FILE__)

describe SystemRole do
  let(:system_role) { FactoryGirl.create(:system_role) }

  it { should_not have_many :members }

  it { should respond_to :permissions }

  it { should have_and_belong_to_many(:groups) }

  it 'should contain test_system_permission' do
    SystemRole.new.setable_permissions.select{|permission| permission.name.eql?(:test_system_permission) }.should_not be_empty
  end

end