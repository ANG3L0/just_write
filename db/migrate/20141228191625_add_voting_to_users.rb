class AddVotingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :score_in, :integer
    add_column :users, :score_out, :integer
  end
end
