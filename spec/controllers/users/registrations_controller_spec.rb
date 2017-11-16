# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  it { should route(:post, '/users').to(action: :create) }
end
