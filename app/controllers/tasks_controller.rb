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
    if safe_create_task
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
  
  def base_permitted_task_params
    [ :title, :description ]
  end
  
  def authorized_permitted_task_params
    :user_id if can? :assign_user_to_task, @task || params[:task][:user_id] == current_user.id
  end
  
  def valid_status_permitted_task_params
    :status if task_status_options.include? params[:task][:status]
  end
  
  def full_permitted_task_params
    base_permitted_task_params << 
      [ authorized_permitted_task_params, valid_status_permitted_task_params ]
  end
  
  def safe_create_task
    begin
      if cannot? :assign_user_to_task, Task
        @task = @project.tasks.create! task_params.merge(user: current_user)
      end
      return true
    rescue ActiveRecord::RecordInvalid
      return false
    end
  end  
  
  def task_params
    params.require(:task).permit(full_permitted_task_params)
  end
  
end
