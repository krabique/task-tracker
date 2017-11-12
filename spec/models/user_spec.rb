# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
    it { should validate_confirmation_of :password }
  end

  context 'associations' do
    it { should have_and_belong_to_many(:projects) }
    it { should have_many(:tasks) }
    it { should have_many(:comments) }
  end
end
