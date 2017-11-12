# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  context 'associations' do
    # it { should belong_to(:user).optional }
    it { should belong_to(:user) }
    it { should belong_to(:project) }
    it { should have_many(:comments) }
  end

  context 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :description }
    it { should validate_presence_of :status }
    it { should validate_presence_of :project }
  end
end
