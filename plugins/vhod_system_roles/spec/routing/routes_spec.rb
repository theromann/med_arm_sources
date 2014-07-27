require File.expand_path("../../spec_helper", __FILE__)

describe RolesController do

  it "routes to index" do
    expect(:get => system_roles_path).to route_to(:controller => "roles", :action => "index")
  end

  it "routes to update" do
    expect(:put => system_role_path(1)).to route_to(:controller => "roles", :action => "update", :id => "1")
  end

  it "routes to system_permissions" do
    expect(:get => system_permissions_path).to route_to(:controller => "roles", :action => "system_permissions")
  end

end
