class AddDefaultValueFalseOnCorrectToAnswer < ActiveRecord::Migration[8.0]
  def change
    change_column_default :answers, :correct, from: false, to: false
  end
end
