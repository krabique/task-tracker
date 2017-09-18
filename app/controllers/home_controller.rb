class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  
  def index
    if current_user
      if current_user.manager_role?
        @projects = Project.where(user: current_user)
      else
        @projects = current_user.projects
      end
    end
  end
end
