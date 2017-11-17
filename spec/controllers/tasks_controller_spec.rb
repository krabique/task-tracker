# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:user) { create(:manager) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, project: project) }

  before(:each) do
    login_with user
  end

  describe 'GET #show' do
    it "sets @new_comment variable to a new unsaved comment with it's task " \
       'set to this task' do
      get :show, params: { id: task.id, project_id: project.id }

      expect(assigns(:new_comment).attributes).to eq(
        Comment.new(task: task).attributes
      )
    end

    it 'renders the :show template' do
      get :show, params: { id: task.id, project_id: project.id }
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    it 'renders the :new template' do
      get :new, params: { project_id: project.id }
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new task in the database' do
        expect do
          post :create, params:
            { project_id: project.id, task: attributes_for(:task) }
        end.to change(Task, :count).by(1)
      end

      it 'redirects to the project page' do
        post :create, params:
          { project_id: project.id, task: attributes_for(:task) }

        assigns(:project).reload

        expect(response).to(
          redirect_to(project_task_path(project, assigns(:task)))
        )
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new project in the database' do
        expect do
          post :create, params:
            { project_id: project.id, task: attributes_for(:invalid_task) }
        end.to_not change(Task, :count)
      end

      it 're-renders the :new template' do
        post :create, params:
          { project_id: project.id, task: attributes_for(:invalid_task) }

        expect(response).to render_template :new
      end
    end

    context 'as a developer' do
      let(:user) { create(:developer) }

      context 'as a member of the project' do
        let(:project) { create(:project, users: [user]) }

        it 'should be able to create a task for this project with this ' \
           "user as the task's owner" do
          post :create, params:
            { project_id: project.id, task: attributes_for(:task) }

          assigns(:task).reload

          expect(assigns(:task).user).to eq user
        end

        it 'should not be able to create a task for this project with ' \
           "this a different user as the task's owner" do
          post :create, params:
            { project_id: project.id, task: attributes_for(:task, user: create(:user)) }

          assigns(:task).reload

          expect(assigns(:task).user).to eq user
        end
      end

      context 'not as a member of the project' do
        let(:project) { create(:project) }
        
        it 'should not be able to create a task for this project' do
          expect do
            post :create, params:
              { project_id: project.id, task: attributes_for(:task) }
          end.to raise_error CanCan::AccessDenied
        end
      end
    end
  end
end
