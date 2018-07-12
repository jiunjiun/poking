class ObserverEvent < ApplicationRecord
  belongs_to :observer

  after_create :check_type

  module Type
    UP   = 'up'
    DOWN = 'DOWN'
  end

  private
  def check_type
    events = self.observer.events.order(:created_at).last(2)

    firstone = events.first
    lastone = events.last

    unless firstone.event_type == lastone.event_type
      SystemMailer.alert(self.observer).deliver!
    end
  end
end
