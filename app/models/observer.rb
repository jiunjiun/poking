class Observer < ApplicationRecord
  belongs_to :user

  has_many :events, class_name: 'ObserverEvent'
  has_many :senders, class_name: 'ObserverSender'
end
