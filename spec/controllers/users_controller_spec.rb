# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET /users/:id' do
    context 'for a developer' do
      let(:user) { create(:developer) }

      it 'should have a 200 status code' do
        login_with user
        get :show, params: { id: user.id }
        expect(response.status).to eq(200)
      end
    end

    context 'for a manager' do
      let(:user) { create(:manager) }

      it 'should have a 200 status code' do
        login_with user
        get :show, params: { id: user.id }
        expect(response.status).to eq(200)
      end
    end
  end
end
