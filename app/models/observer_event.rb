class ObserverEvent < ApplicationRecord
  belongs_to :observer

  before_create :check_dup_type
  after_create :check_type

  module Type
    UP      = 'up'
    DOWN    = 'down'
    STARTED = 'started'
    PAUSED  = 'paused'

    def self.server_type
      [UP, DOWN]
    end

    def self.operator_type
      [STARTED, PAUSED]
    end
  end

  private
  def check_dup_type
    last_event = self.observer.events.order(:created_at).last
    if last_event
      last_event.update duration_at: (Time.now.to_i - last_event.created_at.to_i)
    end

    if last_event.present? and last_event.event_type == self.event_type
      Rails.logger.info { "[Rollback][Current event_type and Last event_type is same]" }
      raise ActiveRecord::Rollback
    end
  end

  def check_type
    events = self.observer.events.order(:created_at).last(2)

    firstone = events.first
    lastone = events.last

    if ObserverEvent::Type.operator_type.include? firstone.event_type or
        ObserverEvent::Type.operator_type.include? lastone.event_type
      return
    end

    unless firstone.event_type == lastone.event_type
      SystemMailer.alert(self.observer).deliver!
    end
  end
end
