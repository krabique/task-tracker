class TasksController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :task, through: :project
  before_action :task_status_options, only: [:new, :edit]

  def show
  end

  def new
  end

  def edit
  end

  def create
    @task = @project.tasks.new(task_params)
    if @task.save
      redirect_to project_task_path(@project, @task), notice: 'Task was successfully created.'
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to project_task_path(@project, @task), notice: 'Task was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: 'Task was successfully destroyed.'
  end


  private

  def task_status_options
    @task_status_options = %w[waiting implementation verifying releasing]
  end
  
  def task_params
    if task_status_options.include? params[:task][:status]
      params.require(:task).permit(:title, :description, :status, :user_id)
    else
      params.require(:task).permit(:title, :description, :user_id)
    end
  end
  
end
