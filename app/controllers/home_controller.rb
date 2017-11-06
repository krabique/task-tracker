# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    if current_user
      @projects = if current_user.manager_role?
                    Project.where(user: current_user)
                  else
                    current_user.projects
                  end
    end
  end
end
