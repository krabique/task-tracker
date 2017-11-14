require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe '.current_ability' do
    it 'should set @current_ability' do
      result = controller.current_ability
      expect(result).to be_truthy
    end
  end
end
