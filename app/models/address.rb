class Address < ApplicationRecord
  belongs_to :contact

  validates :street, presence: true
  validates :number, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :cep, presence: true
end
