# frozen_string_literal: true

class FixNullTrueOnMostFieldsSecond < ActiveRecord::Migration[5.1]
  def change
    change_column :projects, :title, :string, null: false
    change_column :projects, :description, :text, null: false
    change_column :projects, :user_id, :bigint, null: false

    change_column :tasks, :title, :string, null: false
    change_column :tasks, :description, :text, null: false
    change_column :tasks, :status, :string, null: false
    change_column :tasks, :project_id, :bigint, null: false
  end
end
