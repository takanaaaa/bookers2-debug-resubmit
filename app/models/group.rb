class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users

  attachment :image, destroy: false

  validates :name, presence: true
  validates :introduction, presence: true
end
