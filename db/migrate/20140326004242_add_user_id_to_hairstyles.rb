class AddUserIdToHairstyles < ActiveRecord::Migration
  def change
    add_column :hairstyles, :user_id, :integer
  end
end
