class Observer < ApplicationRecord
  belongs_to :user

  has_many :events, class_name: 'ObserverEvent'
  has_many :senders, class_name: 'ObserverSender'

  validates_presence_of :name, :interval

  before_create :setup
  after_create :setup_sender

  module Type
    HTTPs    = 'HTTPs'
    PING     = 'PING'
    KEY_WORD = 'KEY_WORD'
  end

  private
  def setup
    trigger_worker
  end

  def trigger_worker
  end

  def setup_sender
    self.senders.create sender_id: self.user.senders.first.id
  end
end
