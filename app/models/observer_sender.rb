class ObserverSender < ApplicationRecord
  belongs_to :observer
  belongs_to :sender
end
