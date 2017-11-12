# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  context 'associations' do
    it { should belong_to(:task) }
    it { should belong_to(:user) }
  end

  context 'validations' do
    it { should validate_presence_of :body }
    it { should validate_presence_of :task }
    it { should validate_presence_of :user }
  end
end
