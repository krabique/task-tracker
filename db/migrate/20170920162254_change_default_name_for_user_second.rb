class ChangeDefaultNameForUserSecond < ActiveRecord::Migration[5.1]
  def change
    change_column_default :users, :name, nil
  end
end
