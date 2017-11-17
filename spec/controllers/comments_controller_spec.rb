# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:manager) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, project: project) }
  let(:comment) { create(:comment, task: task) }

  before(:each) do
    login_with user
  end

  describe 'GET #new' do
    it 'renders the :new template' do
      get :new, params: { task_id: task.id, project_id: project.id }
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    it 'renders the :edit template' do
      get :edit, params:
        { id: comment.id, task_id: task.id, project_id: project.id }
      expect(response).to render_template :edit
    end
  end

  describe 'PUT #update' do
    context 'with valid attributes' do
      it "changes the comment's attributes and saves it to the database" do
        body = Faker::HarryPotter.quote

        put :update, params: {
          id: comment.id,
          task_id: task.id,
          project_id: project.id,
          comment: attributes_for(:comment, body: body)
        }

        assigns(:comment).reload

        expect(
          Nokogiri::HTML.parse(assigns(:comment).body).text
        ).to eq body
      end

      it 'redirects to the task page' do
        put :update, params:
          { id: comment.id, project_id: project.id, task_id: task.id,
            comment: attributes_for(:comment) }
        expect(response).to redirect_to(
          project_task_path(project, assigns(:task))
        )
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new project in the database' do
        initial_body = comment.body

        put :update, params: {
          id: comment.id,
          task_id: task.id,
          project_id: project.id,
          comment: attributes_for(:comment, body: nil)
        }

        assigns(:comment).reload

        expect(
          Nokogiri::HTML.parse(assigns(:comment).body).text
        ).to eq initial_body
      end

      it 'renders the :edit template' do
        put :update, params: {
          id: comment.id,
          task_id: task.id,
          project_id: project.id,
          comment: attributes_for(:comment, body: nil)
        }

        expect(response).to render_template :edit
      end
    end

    context 'as a developer' do
      let(:user) { create(:developer) }

      context 'as a member of the project' do
        let(:project) { create(:project, users: [user]) }
        let(:task) { create(:task, project: project) }

        context 'for his own comments' do
          let(:comment) { create(:comment, task: task, user: user) }

          it 'should be able to update his own comment' do
            body = Faker::HarryPotter.quote

            put :update, params: {
              id: comment.id,
              task_id: task.id,
              project_id: project.id,
              comment: attributes_for(:comment, body: body)
            }

            assigns(:comment).reload

            expect(
              Nokogiri::HTML.parse(assigns(:comment).body).text
            ).to eq body
          end
        end

        context 'not for his own comments' do
          let(:comment) { create(:comment, task: task) }

          it "should not be able to update others' comments" do
            body = Faker::HarryPotter.quote

            expect do
              put :update, params: {
                id: comment.id,
                task_id: task.id,
                project_id: project.id,
                comment: attributes_for(:comment, body: body)
              }
            end.to raise_error CanCan::AccessDenied
          end
        end
      end
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new comment in the database' do
        body = Faker::HarryPotter.quote

        expect do
          post :create, params: {
            task_id: task.id,
            project_id: project.id,
            comment: attributes_for(:comment, body: body)
          }
        end.to change(Task, :count).by(1)
      end

      it "redirects to the task's page" do
        body = Faker::HarryPotter.quote

        post :create, params: {
          task_id: task.id,
          project_id: project.id,
          comment: attributes_for(:comment, body: body)
        }

        assigns(:comment).reload

        expect(response).to(
          redirect_to(project_task_path(project, assigns(:task)))
        )
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new comment in the database' do
        expect do
          post :create, params: {
            task_id: task.id,
            project_id: project.id,
            comment: attributes_for(:invalid_comment)
          }
        end.to_not change(Comment, :count)
      end

      it 're-renders the :new template' do
        post :create, params: {
          task_id: task.id,
          project_id: project.id,
          comment: attributes_for(:invalid_comment)
        }

        expect(response).to render_template :new
      end
    end

    context 'as a developer' do
      let(:user) { create(:developer) }

      context 'as a member of the project' do
        let(:project) { create(:project, users: [user]) }
        let(:task) { create(:task, project: project) }

        it 'should be able to create his own comment' do
          expect do
            post :create, params: {
              task_id: task.id,
              project_id: project.id,
              comment: attributes_for(:comment)
            }
          end.to change(Task, :count).by(1)
        end

        it 'should not be able to create comments as someone else' do
          post :create, params: {
            task_id: task.id,
            project_id: project.id,
            comment: attributes_for(:comment, user: create(:user))
          }

          expect(assigns(:comment).user).to eq user
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:comment) do
      create(:comment, user: user, task: task)
    end

    it 'destroys the comment' do
      expect do
        delete :destroy, params:
          { id: comment.id, task_id: task.id, project_id: project.id }
      end.to change(Comment, :count).by(-1)
    end

    it "redirects to the task's page" do
      delete :destroy, params:
        { id: comment.id, task_id: task.id, project_id: project.id }

      expect(response).to(
        redirect_to(project_task_path(project, assigns(:task)))
      )
    end

    context "not as the project's owner" do
      let(:project) { create(:project) }

      it 'should not be able to delete the comment' do
        expect do
          delete :destroy, params:
            { id: comment.id, task_id: task.id, project_id: project.id }
        end.to raise_error CanCan::AccessDenied
      end
    end

    context 'as a developer' do
      let(:user) { create(:developer) }

      context 'as a member of the project' do
        let(:project) { create(:project, users: [user]) }
        let(:task) { create(:task, project: project) }
        let(:comment) { create(:comment, task: task) }

        it "should not be able to delete the others' comments" do
          expect do
            delete :destroy, params:
              { id: comment.id, task_id: task.id, project_id: project.id }
          end.to raise_error CanCan::AccessDenied
        end

        context 'for his own comment' do
          let(:comment) { create(:comment, task: task, user: user) }

          it 'should be able to delete his own comments' do
            expect do
              delete :destroy, params:
                { id: comment.id, task_id: task.id, project_id: project.id }
            end.to change(Comment, :count).by(-1)
          end
        end
      end
    end
  end
end
