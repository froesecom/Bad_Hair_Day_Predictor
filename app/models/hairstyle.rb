# == Schema Information
#
# Table name: hairstyles
#
#  id            :integer          not null, primary key
#  style_name    :string(255)
#  length        :string(255)
#  curliness     :string(255)
#  hygiene       :string(255)
#  modifications :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class Hairstyle < ActiveRecord::Base
  attr_accessible :style_name, :length, :curliness, :hygiene, :modifications
  has_and_belongs_to_many :users

  def self.current_attributes
    {
      :length_attributes => {'no hair' => 0.0, 'very short' => 1.0, 'short' => 2.0, 'jaw-length' => 3.0, 'shoulder-length' => 4.0, 'back-length+' => 5.0},
      :curliness_attributes => {'straight'=> 2.5, 'wavy' => 4.0, 'curly' => 5, 'afro' => 2.0},
      :hygiene_attributes => {'today' => 1, 'yesterday' => 2.0, 'days ago' => 5, 'can’t remember' => 10.0},
      :modification_attributes => {'recent haircut' => -2.5, 'hair product' => -1, 'perm' => 1.0,  'dye'=> 1.0, 'highlights' => 1.0} 
    }
  end

end
