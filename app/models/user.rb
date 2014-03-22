# == Schema Information
#
# Table name: users
#
#  id                       :integer          not null, primary key
#  name                     :string(255)
#  email                    :text
#  password_digest          :string(255)
#  gender                   :string(255)
#  country                  :string(255)
#  city                     :text
#  humidity_susceptibility  :decimal(, )
#  thickness_susceptibility :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :name, :email, :gender, :country, :city, :humidity_susceptibility, :thickness_susceptibility
  has_and_belongs_to_many :hairstyles
end
