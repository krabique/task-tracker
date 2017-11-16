# frozen_string_literal: true

class ProjectsController < ApplicationController
  load_and_authorize_resource

  def index
    @projects = Project.includes(:user).all
  end

  def show
    @new_task = Task.new(project: @project)
  end

  def new; end

  def edit; end

  def create
    if safe_create_project
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render :new
    end
  end

  def update
    params[:project][:user_ids] ||= []
    if @project.update(project_params)
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_url, notice: 'Project was successfully destroyed.'
  end

  private

  def project_params
    params.require(:project).permit(:title, :description, user_ids: [])
  end

  def safe_create_project
    @project = Project.create! project_params.merge(user: current_user)
    return true
  rescue ActiveRecord::RecordInvalid
    return false
  end
end
