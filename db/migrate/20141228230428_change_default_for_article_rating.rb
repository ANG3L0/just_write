class ChangeDefaultForArticleRating < ActiveRecord::Migration
  def change
		change_column :articles, :rating, :integer, default: 3
  end
end
