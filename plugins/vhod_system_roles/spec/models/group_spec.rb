require File.expand_path("../../spec_helper", __FILE__)

describe Group do
  it { should have_and_belong_to_many(:system_roles) }
end