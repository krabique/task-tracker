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
           "a different user as the task's owner" do
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

  describe 'GET #edit' do
    it 'renders the :edit template' do
      get :edit, params: { id: task.id, project_id: project.id }
      expect(response).to render_template :edit
    end
  end

  describe 'PUT #update' do
    context 'with valid attributes' do
      it "changes the task's attributes and saves it to the database" do
        title = Faker::HarryPotter.book
        description = Faker::HarryPotter.quote
        status = attributes_for(:task)[:status]

        put :update, params: {
          id: task.id,
          project_id: project.id,
          task: attributes_for(:task,
                               title: title,
                               description: description,
                               status: status)
        }

        assigns(:task).reload

        expect(
          Nokogiri::HTML.parse(assigns(:task).title).text
        ).to eq title

        expect(
          Nokogiri::HTML.parse(assigns(:task).description).text
        ).to eq description

        expect(
          Nokogiri::HTML.parse(assigns(:task).status).text
        ).to eq status
      end

      it 'redirects to the task page' do
        put :update, params:
          { project_id: project.id, id: task.id, task: attributes_for(:task) }
        expect(response).to redirect_to(
          project_task_path(project, assigns(:task))
        )
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new project in the database' do
        initial_title = task.title
        initial_description = task.description
        initial_status = task.status

        put :update, params: {
          id: task.id,
          project_id: project.id,
          task: attributes_for(:task,
                               title: nil,
                               description: nil,
                               status: nil)
        }

        assigns(:task).reload

        expect(
          Nokogiri::HTML.parse(assigns(:task).title).text
        ).to eq initial_title

        expect(
          Nokogiri::HTML.parse(assigns(:task).description).text
        ).to eq initial_description

        expect(
          Nokogiri::HTML.parse(assigns(:task).status).text
        ).to eq initial_status
      end

      it 're-renders the :new template' do
        put :update, params: {
          id: task.id,
          project_id: project.id,
          task: attributes_for(:task,
                               title: nil,
                               description: nil,
                               status: nil)
        }

        expect(response).to render_template :edit
      end
    end

    context 'as a developer' do
      let(:user) { create(:developer) }

      context 'as a member of the project' do
        let(:project) { create(:project, users: [user]) }
        let(:task) { create(:task, project: project, user: user) }

        it 'should be able to update a task for this project with this ' \
           "user as the task's owner (assigned developer)" do
          title = Faker::HarryPotter.book
          description = Faker::HarryPotter.quote
          status = attributes_for(:task)[:status]

          put :update, params: {
            id: task.id,
            project_id: project.id,
            task: attributes_for(:task,
                                 title: title,
                                 description: description,
                                 status: status)
          }

          expect(
            Nokogiri::HTML.parse(assigns(:task).title).text
          ).to eq title

          expect(
            Nokogiri::HTML.parse(assigns(:task).description).text
          ).to eq description

          expect(
            Nokogiri::HTML.parse(assigns(:task).status).text
          ).to eq status
        end

        it 'should not be able to update a task for this project with ' \
          "a different user as the task's owner" do
          post :update, params:
            { id: task.id,
              project_id: project.id,
              task: attributes_for(:task, user: create(:user)) }

          assigns(:task).reload

          expect(assigns(:task).user).to eq user
        end

        context 'not on his own task' do
          let(:task) { create(:task) }

          it 'should not be able to update it' do
          end
        end
      end

      context 'not as a member of the project' do
        let(:project) { create(:project) }

        it 'should not be able to update a task for this project' do
          expect do
            post :update, params:
              { id: task.id,
                project_id: project.id,
                task: attributes_for(:task) }
          end.to raise_error CanCan::AccessDenied
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:task) { create(:task, user: user, project: project) }

    it 'destroys the task' do
      expect do
        delete :destroy, params: { id: task.id, project_id: project.id }
      end.to change(Task, :count).by(-1)
    end

    it "redirects to the task's project page" do
      delete :destroy, params: { id: task.id, project_id: project.id }
      expect(response).to redirect_to project
    end

    context "not as the project's owner" do
      let(:project) { create(:project) }

      it 'should not be able to delete the project' do
        expect do
          delete :destroy, params: { id: task.id, project_id: project.id }
        end.to raise_error CanCan::AccessDenied
      end
    end

    context 'as a developer' do
      let(:user) { create(:developer) }

      context "not as the task's owner" do
        it 'should not be able to delete the project' do
          expect do
            delete :destroy, params: { id: task.id, project_id: project.id }
          end.to raise_error CanCan::AccessDenied
        end
      end
    end
  end
end
