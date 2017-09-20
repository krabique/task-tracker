class FixNullTrueOnMostFields < ActiveRecord::Migration[5.1]
  def change
    change_column :comments, :body, :text, null: false
    change_column :comments, :task_id, :bigint, null: false
    change_column :comments, :user_id, :bigint, null: false
    
    # more on the next migration
  end
end
