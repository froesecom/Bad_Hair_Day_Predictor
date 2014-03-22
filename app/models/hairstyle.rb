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
end
