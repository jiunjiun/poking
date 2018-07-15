class Observer < ApplicationRecord
  belongs_to :user

  has_many :events, class_name: 'ObserverEvent'
  has_many :records, class_name: 'ObserverRecord'
  has_many :observer_senders
  has_many :senders, through: :observer_senders
  has_many :regions, class_name: 'ObserverRegion'

  acts_as_paranoid

  validates_presence_of :name, :interval

  before_create :setup
  after_create :after_create_setup
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

    self.events.create({
      event_type: ObserverEvent::Type::STARTED,
      reason: ObserverEvent::Type::STARTED.upcase
    })

    trigger_worker
  end

  def paruse!
    self.update status: Status::PAUSED

    self.events.create({
      event_type: ObserverEvent::Type::PAUSED,
      reason: ObserverEvent::Type::PAUSED.upcase
    })
  end

  def lastday_records
    self.records.where(created_at: (1.days.ago..DateTime.now))
  end

  def last7day_records
    self.records.where(created_at: (7.days.ago..DateTime.now))
  end

  def lastmonth_records
    self.records.where(created_at: (1.months.ago..DateTime.now))
  end

  def statistics
    return @statistics if @statistics

    lastday_response_time_avg   = ((self.lastday_records.average(:response_time) || 0)   * 1000).to_i
    last7day_response_time_avg  = ((self.last7day_records.average(:response_time) || 0)  * 1000).to_i
    lastmonth_response_time_avg = ((self.lastmonth_records.average(:response_time) || 0) * 1000).to_i

    lastday_down_count = self.lastday_records.where(event_type: ObserverEvent::Type::DOWN).count
    lastday_count      = self.lastday_records.count

    if lastday_count == 0
      lastday_down_rate = 0
    else
      lastday_down_rate  = ((lastday_count - lastday_down_count) / lastday_count.to_f * 100).round(2)
    end

    last7day_down_count = self.last7day_records.where(event_type: ObserverEvent::Type::DOWN).count
    last7day_count      = self.last7day_records.count

    if last7day_count == 0
      last7day_down_rate = 0
    else
      last7day_down_rate  = ((last7day_count - last7day_down_count) / last7day_count.to_f * 100).round(2)
    end

    lastmonth_down_count = self.lastmonth_records.where(event_type: ObserverEvent::Type::DOWN).count
    lastmonth_count      = self.lastmonth_records.count

    if lastmonth_count == 0
      lastmonth_down_rate = 0
    else
      lastmonth_down_rate  = ((lastmonth_count - lastmonth_down_count) / lastmonth_count.to_f * 100).round(2)
    end

    @statistics ||= {
      lastday_response_time_avg: lastday_response_time_avg,
      last7day_response_time_avg: last7day_response_time_avg,
      lastmonth_response_time_avg: lastmonth_response_time_avg,
      lastday_down_rate: lastday_down_rate,
      last7day_down_rate: last7day_down_rate,
      lastmonth_down_rate: lastmonth_down_rate,
    }
  end

  def worker_status
    job_id = $redis.get("observer_#{self.id}")
  end

  def check_worker
    # https://stackoverflow.com/questions/28088620/how-do-you-go-about-rescheduling-a-job-in-sidekiq
    if self.status == Observer::Status::STARTED and !Sidekiq::ScheduledSet.new.find_job(self.worker_status)
      trigger_worker
    end
  end

  private
  def setup
  end

  def after_create_setup
    self.observer_senders.create sender_id: self.user.senders.first.id, enable: true
    self.regions.create region_type: ObserverRegion::Type::ASIA_EAST1, enable: true
  end

  def trigger_worker
    sleep 0.5

    self.regions.each do |region|
      Rails.logger.debug { " -- [Observer][TriggerWorker]: #{self.id}" }
      ObserverHttpsWorker.set(queue: region.region_type).perform_async self.id
    end
  end
end
