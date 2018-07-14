class ObserverRegion < ApplicationRecord
  belongs_to :observer

  module Type
    ASIA_EAST1 = 'asia-east1'
  end
end
