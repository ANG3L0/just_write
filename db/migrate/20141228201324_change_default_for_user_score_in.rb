class ChangeDefaultForUserScoreIn < ActiveRecord::Migration
  def change
		change_column :users, :score_in, :integer, default: 19
  end
end
