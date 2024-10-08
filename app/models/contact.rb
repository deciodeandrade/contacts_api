class Contact < ApplicationRecord

  belongs_to :user
  has_one :address, dependent: :destroy

  accepts_nested_attributes_for :address

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { scope: :user_id }
  validates :cpf, presence: true, uniqueness: { scope: :user_id }

  validate :valid_cpf_format

  scope :search, -> query { where("name ILIKE :query OR cpf ILIKE :query", query: "%#{query}%") if query.present? }

  private

  def valid_cpf_format
    unless CPF.valid?(cpf)
      errors.add(:cpf, 'não é um CPF válido')
    end
  end
end
