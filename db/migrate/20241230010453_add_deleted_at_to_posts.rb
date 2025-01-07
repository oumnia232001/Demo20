class AddDeletedAtToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :deleted_at, :datetime
  end
end
