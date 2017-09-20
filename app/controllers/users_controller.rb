class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
    if @user.manager_role?
      @projects = Project.where(user: @user)
    else
      @projects = @user.projects
    end
  end
  
end
