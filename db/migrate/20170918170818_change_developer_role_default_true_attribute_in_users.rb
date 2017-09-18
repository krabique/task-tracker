class ChangeDeveloperRoleDefaultTrueAttributeInUsers < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :developer_role, :boolean, default: false
  end
end
