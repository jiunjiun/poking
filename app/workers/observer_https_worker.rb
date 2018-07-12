class ObserverHttpsWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  sidekiq_options retry: 0
  sidekiq_options queue: 'haha'

  def perform observer_id, opts={}
    observer = Observer.find_by_id observer_id

    if observer.present?
      event_type    = ObserverEvent::Type::DOWN
      response      = nil
      response_time = nil
      response_code = nil

      begin
        time = Benchmark.measure do
          response = RestClient::Request.execute(method: observer.http_method, url: observer.url, timeout: 120)
        end
        Rails.logger.debug { " -- time: #{time}" }
        Rails.logger.debug { " -- time: #{time.real}" }

        event_type = ObserverEvent::Type::UP
        response_time = time.real
        response_code = response.code
      rescue Exception => e
        Rails.logger.debug { "[ObserverHttpsWorker]: #{e}" }
      end


      observer.events.create({
        event_type: event_type,
        response_time: response_time,
        response_code: response_code,
      })

      if observer.status == Observer::Status::STARTED
        ObserverHttpsWorker.perform_in(observer.interval.to_i.minutes, observer.id)
      end
    end
  end
end


