# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :project
  has_many :comments
end
