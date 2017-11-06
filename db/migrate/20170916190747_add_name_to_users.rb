# frozen_string_literal: true

class AddNameToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :name, :string, null: false, default: 'Anonymous'
  end
end
