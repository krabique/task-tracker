require 'rails_helper'

RSpec.describe Project, type: :model do
  before(:each) do
    @user = create(:user)
    @project = create(:project, user: @user)
  end  
  
  it "has a valid factory" do
    expect(@project).to be_valid
  end
end
