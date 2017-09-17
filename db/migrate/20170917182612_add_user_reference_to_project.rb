class AddUserReferenceToProject < ActiveRecord::Migration[5.1]
  def change
    add_reference :projects, :user, foreign_key: true
    remove_column :projects, :creator_id
  end
end
