# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @projects = if @user.manager_role?
                  Project.where(user: @user)
                else
                  @user.projects
                end
  end
end
