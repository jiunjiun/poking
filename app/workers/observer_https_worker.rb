class ObserverHttpsWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  sidekiq_options retry: 0
  # sidekiq_options queue: 'haha'

  def perform observer_id, opts={}
    observer = Observer.find_by_id observer_id

    if observer.present?
      event_type    = nil
      response      = nil
      response_time = nil
      response_code = nil
      time          = nil
      reason        = nil

      begin
        time = Benchmark.measure do
          response = RestClient::Request.execute(method: observer.http_method, url: observer.url, timeout: 120)
        end
        event_type    = ObserverEvent::Type::UP
        response_time = time.real
        response_code = response.code
        reason = "OK (#{response_code})"

      rescue RestClient::ExceptionWithResponse => e
        event_type = ObserverEvent::Type::DOWN
        response_code = e.response.try(:code)
        reason = e

      rescue RestClient::RequestFailed => e
        event_type = ObserverEvent::Type::DOWN
        response_code = e.response.try(:code)
        reason = e

      rescue Exception => e
        Rails.logger.debug { "[ObserverHttpsWorker][e]: #{e}" }

        event_type = ObserverEvent::Type::DOWN
        response_code = e.try(:response).try(:code)
        reason = e
      end

      if observer.status == Observer::Status::STARTED
        observer.events.create({
          event_type: event_type,
          reason: reason
        })

        if observer.events.last.event_type == ObserverEvent::Type::UP
          observer.records.create({
            event_type: event_type,
            response_time: response_time,
            response_code: response_code,
          })
        end

        ObserverHttpsWorker.perform_in(observer.interval.to_i.minutes, observer.id)
      end
    end
  end
end


