class Sender < ApplicationRecord
  belongs_to :user

  has_many :observer_senders, dependent: :destroy
end
