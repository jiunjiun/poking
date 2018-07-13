class Sender < ApplicationRecord
  belongs_to :user

  has_many :observer_senders, dependent: :destroy

  validates :email, uniqueness: true

  before_save    :check_account
  before_destroy :check_account

  private
  def check_account
    if self.user.email == self.email_was
      Rails.logger.info { "[Rollback][CheckAccount]" }
      raise ActiveRecord::Rollback
    end
  end
end
