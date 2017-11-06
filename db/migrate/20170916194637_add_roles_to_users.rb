# frozen_string_literal: true

class AddRolesToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :developer_role, :boolean, default: true
    add_column :users, :manager_role, :boolean, default: false
  end
end
