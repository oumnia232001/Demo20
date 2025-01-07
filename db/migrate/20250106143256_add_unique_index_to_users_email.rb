class AddUniqueIndexToUsersEmail < ActiveRecord::Migration[6.0]
  def change
    add_index :users, :email, unique: true, where: "deleted_at IS NULL"
  end
end
