class DropUsersHairstyles < ActiveRecord::Migration
  def change
    drop_table :hairstyles_users
  end
end
