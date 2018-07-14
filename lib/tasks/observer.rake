namespace :observer  do
  desc "check observer worker and reschedule"
  task check_worker: :environment do
    Rails.logger.info { "[Task][Observer][CheckWorker] - start" }
    Observer.all.each do |observer|
      observer.check_worker
    end
    Rails.logger.info { "[Task][Observer][CheckWorker] - end" }
  end
end
