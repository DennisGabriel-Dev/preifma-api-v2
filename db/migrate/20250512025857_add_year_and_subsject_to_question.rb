class AddYearAndSubsjectToQuestion < ActiveRecord::Migration[8.0]
  def change
    add_column :questions, :year, :integer
    add_column :questions, :subject, :string
  end
end
