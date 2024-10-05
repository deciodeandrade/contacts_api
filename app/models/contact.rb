class Contact < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :cpf, presence: true, uniqueness: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true

  validate :valid_cpf_format

  private

  def valid_cpf_format
    unless CPF.valid?(cpf)
      errors.add(:cpf, 'não é um CPF válido')
    end
  end
end
