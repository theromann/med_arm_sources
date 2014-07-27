require File.expand_path("../../spec_helper", __FILE__)

describe Role do

  it 'should not contain test_system_permission' do
    Role.new.setable_permissions.select{|permission| permission.name.eql?(:test_system_permission) }.should be_empty
  end

end


