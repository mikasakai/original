class Item < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  has_many :ownerships  , foreign_key: "item_id" , dependent: :destroy
  has_many :users , through: :ownerships
  
  has_many :wants , foreign_key: "item_id", dependent: :destroy
  has_many :want_users , through: :wants, source: :user
  has_many :haves, class_name: "Have", foreign_key: "item_id", dependent: :destroy
  has_many :have_users , through: :haves, source: :user
  
  belongs_to :category
  
end
