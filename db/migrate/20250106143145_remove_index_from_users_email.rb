class RemoveIndexFromUsersEmail < ActiveRecord::Migration[6.0]
  def change
    remove_index :users, :email if index_exists?(:users, :email)
  end
end
