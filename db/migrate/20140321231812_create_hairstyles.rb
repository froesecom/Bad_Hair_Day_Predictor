class CreateHairstyles < ActiveRecord::Migration
  def change
    create_table :hairstyles do |t|
      t.string :style_name
      t.string :length
      t.string :curliness
      t.string :hygiene
      t.string :modifications
      t.timestamps
    end
  end
end
