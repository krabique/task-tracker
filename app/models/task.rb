# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :project
  has_many :comments

  validates :title, presence: true, length: { maximum: 120 }
  validates :description, presence: true
  validates :status, presence: true, inclusion:
    { in: %w[waiting implementation verifying releasing] }
  validates :project, presence: true
end
