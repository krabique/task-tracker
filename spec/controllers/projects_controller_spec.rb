# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:user) { create(:manager) }
  let(:project) { create(:project) }
  let(:invalid_project) { create(:invalid_project) }

  before(:each) do
    login_with user
  end

  describe 'GET #index' do
    it 'sets @projects variable to a collection of all ' \
       'projects with their users' do
      get :index
      expect(assigns(:projects)).to eq Project.includes(:user).all
    end
    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it "sets @new_task variable to a new unsaved task with it's project " \
       'set to this project' do
      get :show, params: { id: project.id }

      expect(assigns(:new_task).attributes).to eq(
        Task.new(project: project).attributes
      )
    end

    it 'renders the :show template' do
      get :show, params: { id: project.id }
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    it 'renders the :new template' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new project in the database' do
        expect do
          post :create, params: { project: attributes_for(:project_with_users) }
        end.to change(Project, :count).by(1)
      end
      it 'redirects to the project page' do
        post :create, params: { project: attributes_for(:project_with_users) }
        expect(response).to redirect_to Project.last
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new project in the database' do
        expect do
          post :create, params: { project: attributes_for(:invalid_project) }
        end.to_not change(Project, :count)
      end

      it 're-renders the :new template' do
        post :create, params: { project: attributes_for(:invalid_project) }
        expect(response).to render_template :new
      end
    end

    context 'when trying to assign a project to a different user ' \
            "(shouldn't be possible)" do
      it 'should not create a project' do
        other_user = create(:manager)
        post :create, params: {
          project: attributes_for(:project, user: other_user)
        }

        assigns(:project).reload

        expect(assigns(:project).user).to_not eq other_user
        expect(assigns(:project).user).to eq user
      end
    end
  end

  describe 'GET #edit' do
    let(:project) { create(:project, user: user) }

    it 'renders the :edit template' do
      get :edit, params: { id: project.id }
      expect(response).to render_template :edit
    end
  end

  describe 'PUT #update' do
    let(:project) { create(:project, user: user) }

    context 'with valid attributes' do
      it "changes the project's attributes and saves it to the database" do
        title = Faker::HarryPotter.book
        description = Faker::HarryPotter.quote

        put :update, params: {
          id: project.id,
          project: attributes_for(:project,
                                  title: title,
                                  description: description)
        }

        assigns(:project).reload

        expect(
          Nokogiri::HTML.parse(assigns(:project).title).text
        ).to eq title

        expect(
          Nokogiri::HTML.parse(assigns(:project).description).text
        ).to eq description
      end

      it 'redirects to the project page' do
        put :update, params:
          { id: project.id, project: attributes_for(:project) }
        expect(response).to redirect_to project
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new project in the database' do
        initial_title = project.title
        initial_description = project.description

        put :update, params: {
          id: project.id,
          project: attributes_for(:project,
                                  title: nil,
                                  description: nil)
        }

        assigns(:project).reload

        expect(
          Nokogiri::HTML.parse(assigns(:project).title).text
        ).to eq initial_title

        expect(
          Nokogiri::HTML.parse(assigns(:project).description).text
        ).to eq initial_description
      end
      it 're-renders the :new template' do
        put :update, params: {
          id: project.id,
          project: attributes_for(:project,
                                  title: nil,
                                  description: nil)
        }

        expect(response).to render_template :edit
      end
    end

    context 'when trying to assign a project to a different user ' \
            "(shouldn't be possible)" do
      it 'should not create a project' do
        other_user = create(:manager)
        put :update, params: {
          id: project.id,
          project: attributes_for(:project, user: other_user)
        }

        assigns(:project).reload

        expect(assigns(:project).user).to_not eq other_user
        expect(assigns(:project).user).to eq user
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:project) { create(:project, user: user) }

    it 'destroys the project' do
      expect do
        delete :destroy, params: { id: project.id }
      end.to change(Project, :count).by(-1)
    end

    it 'redirects to the all projects page' do
      delete :destroy, params: { id: project.id }
      expect(response).to redirect_to projects_url
    end
  end
end
