# frozen_string_literal: true

class CreateJoinTableProjectUser < ActiveRecord::Migration[5.1]
  def change
    create_join_table :projects, :users do |t|
      t.index %i[project_id user_id]
      # t.index [:user_id, :project_id]
    end
  end
end
