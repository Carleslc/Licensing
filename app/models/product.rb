class Product < ApplicationRecord
  has_many :licenses

  validates :name, presence: true

end
