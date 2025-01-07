class UpdateUniqueIndexOnUsers < ActiveRecord::Migration[6.1]
  def change
    # delete l'ancien index UNIQUE sur l'email
    remove_index :users, :email if index_exists?(:users, :email)

    # Ajouter un nouvel index UNIQUE avec une condition
    add_index :users, :email, unique: true, where: "deleted_at IS NULL"
  end
end
