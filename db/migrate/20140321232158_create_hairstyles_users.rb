class CreateHairstylesUsers < ActiveRecord::Migration
  def change
    create_table :hairstyles_users, :id => false do |t|
    t.integer :hairstyle_id
    t.integer :user_id
    end
  end
end
