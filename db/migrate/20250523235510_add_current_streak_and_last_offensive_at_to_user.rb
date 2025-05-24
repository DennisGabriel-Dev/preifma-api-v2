class AddCurrentStreakAndLastOffensiveAtToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :current_streak, :integer, default: 0
    add_column :users, :last_offensive_at, :datetime
  end
end
