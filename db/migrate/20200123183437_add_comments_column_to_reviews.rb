class AddCommentsColumnToReviews < ActiveRecord::Migration[5.2]
  def change
    add_column :reviews, :comments, :string
  end
end
