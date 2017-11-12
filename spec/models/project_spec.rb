# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  context 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :description }
    it { should validate_presence_of :user }
  end

  context 'associations' do
    it { should have_and_belong_to_many(:users) }
    it { should belong_to(:user) }
    it { should have_many(:tasks) }
  end

  # before(:each) do
  #   @user = create(:user)
  #   @project = create(:project, user: @user)
  # end

  # it "has a valid factory" do
  #   expect(@project).to be_valid
  # end
end
