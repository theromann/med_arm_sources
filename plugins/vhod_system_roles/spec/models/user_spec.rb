require File.expand_path("../../spec_helper", __FILE__)

describe User do
  let(:user) { User.find_by_login('rhill').nil? ? FactoryGirl.create(:user) : User.find_by_login('rhill') }
  let(:system_role) { FactoryGirl.create(:system_role) }
  let(:group_guid) { "84260c6f4051d44d842c54e1d0145fee"}

  it { should have_and_belong_to_many :system_roles }

  it '.allowed_to? without system_role' do
    user.allowed_to?(:test_system_permission, :system).should be_false
  end

  it '.allowed_to? with system_role' do
    user.system_roles << system_role
    user.allowed_to?(:test_system_permission, :system).should be_true
  end

  it 'admin is not .allowed_to? absent controller' do
    user.admin = true
    user.save

    user.allowed_to?({:controller => :issue_moves, :action => :move}, FactoryGirl.build(:project)).should be_false
  end

  describe "nil context" do
    it 'does not use system roles on nil context' do
      user.system_roles << system_role
      user.allowed_to?(:test_system_permission, nil).should be_false
    end
  end

  describe "active directory logic" do
    let(:group) { FactoryGirl.create(:group) }
    before(:each) do
      FactoryGirl.create(:user_object_guid)
      user.groups << group
    end

    #it 'can get all groups object_guids' do
    #  user.groups_object_guids.should eq [group_guid]
    #end

    describe "with ldap authentication" do
      before(:each) do
        ldap = FactoryGirl.create(:auth_source_ldap)
        user.auth_source = ldap
        system_role.groups << group
      end

      it '.system_roles' do
        user.system_roles.should eq [system_role]
      end

    end

  end

end