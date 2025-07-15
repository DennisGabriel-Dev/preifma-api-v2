class AddTypeToQuestion < ActiveRecord::Migration[8.0]
  def change
    add_column :questions, :type_question, :integer
  end
end
