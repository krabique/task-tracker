require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  context 'when user is a manager' do
    let!(:user) { create(:manager) }
    let!(:project) { create(:project, user: user) }
    
    it "should set @projects to user's projects" do
      login_with user
      get :index

      expect(response.status).to eq(200)
      expect(assigns(:projects)).to eq Project.where(user: user)
    end
  end
  
  context 'when user is a developer' do
    let!(:user) { create(:developer, projects: [project]) }
    let!(:project) { create(:project) }
    
    it "should set @projects to user's projects" do
      login_with user
      get :index

      expect(response.status).to eq(200)
      expect(assigns(:projects)).to eq user.projects
    end
  end
end
