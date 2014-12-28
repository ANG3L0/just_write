class ChangeDefaultForUserScoreOut < ActiveRecord::Migration
  def change
		change_column :users, :score_out, :integer, default: 10
  end
end
