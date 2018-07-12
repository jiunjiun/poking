class Observer < ApplicationRecord
  belongs_to :user

  has_many :events, class_name: 'ObserverEvent'
  has_many :observer_senders
  has_many :senders, through: :observer_senders

  acts_as_paranoid

  validates_presence_of :name, :interval

  before_create :setup
  after_create :setup_sender
  after_create :trigger_worker

  module Type
    HTTPs    = 'HTTPs'
    PING     = 'PING'
    KEY_WORD = 'KEY_WORD'
  end

  module Status
    STARTED = 'started'
    PAUSED  = 'paused'
  end

  module HttpMethod
    GET    = 'get'
    POST   = 'post'
    PUT    = 'put'
    PATCH  = 'patch'
    DELETE = 'delete'
  end

  def start!
    self.update status: Status::STARTED
    trigger_worker
  end

  def paruse!
    self.update status: Status::PAUSED
  end

  def lastday_events
    self.events.where(created_at: (1.days.ago..DateTime.now))
  end

  def last7day_events
    self.events.where(created_at: (7.days.ago..DateTime.now))
  end

  def lastmonth_events
    self.events.where(created_at: (1.months.ago..DateTime.now))
  end

  private
  def setup
  end

  def trigger_worker
    ObserverHttpsWorker.perform_async self.id
  end

  def setup_sender
    self.observer_senders.create sender_id: self.user.senders.first.id
  end
end
