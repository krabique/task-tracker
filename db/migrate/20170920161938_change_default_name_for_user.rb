# frozen_string_literal: true

class ChangeDefaultNameForUser < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :name, :string, null: false
  end
end
