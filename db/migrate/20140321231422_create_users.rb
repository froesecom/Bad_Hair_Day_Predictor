class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.text :email
      t.string :password_digest
      t.string :gender
      t.string :country
      t.text :city
      t.decimal :humidity_susceptibility
      t.decimal :thickness_susceptibility
      t.timestamp
    end
  end
end
