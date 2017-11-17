# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :task
  belongs_to :user

  validates :body, presence: true
  validates :task, presence: true
  validates :user, presence: true
end
