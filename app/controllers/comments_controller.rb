# frozen_string_literal: true

class CommentsController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :task, through: :project
  load_and_authorize_resource :comment, through: :task

  def new; end

  def edit; end

  def create
    if safe_create_comment
      redirect_to project_task_path(@project, @task),
                  notice: 'Comment was successfully created.'
    else
      flash[:alert] = 'There was a problem creating the comment.'
      render :new
    end
  end

  def update
    if @comment.update(comment_params)
      redirect_to project_task_path(@project, @task),
                  notice: 'Comment was successfully updated.'
    else
      flash[:alert] = 'There was a problem updating the comment.'
      render :edit
    end
  end

  def destroy
    Comment.find(params[:id]).destroy
    redirect_to project_task_path(@project, @task),
                notice: 'Comment was successfully destroyed.'
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def safe_create_comment
    @comment = @task.comments.create! comment_params.merge(user: current_user)
    return true
  rescue ActiveRecord::RecordInvalid
    return false
  end
end
