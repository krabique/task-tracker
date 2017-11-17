# frozen_string_literal: true

class Project < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :tasks
  belongs_to :user

  validates :title, presence: true
  validates :description, presence: true
  validates :user, presence: true
end
