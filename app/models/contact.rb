class Contact < ApplicationRecord

  belongs_to :user

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { scope: :user_id }
  validates :cpf, presence: true, uniqueness: { scope: :user_id }
  validates :city, presence: true
  validates :state, presence: true

  validate :valid_cpf_format

  scope :search, -> query { where("name ILIKE :query OR cpf ILIKE :query", query: "%#{query}%") if query.present? }

  private

  def valid_cpf_format
    unless CPF.valid?(cpf)
      errors.add(:cpf, 'não é um CPF válido')
    end
  end
end
