class AddTypeToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :type_user, :integer, default: 1
  end
end
