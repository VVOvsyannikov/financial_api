class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0 }

  after_initialize :set_default_balance, if: :new_record?

  private

  def set_default_balance
    self.balance ||= 0.0
  end
end
