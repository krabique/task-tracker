# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  def current_ability
    @current_ability ||= Ability.new(current_user, @project)
  end
end
