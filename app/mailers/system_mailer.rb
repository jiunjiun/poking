class SystemMailer < ApplicationMailer
  default from: "services@#{Settings.domain.host}"

  def alert observer
    if observer.present?
      @observer = observer

      Rails.logger.info { "[SystemMailer][sender_mails]: #{sender_mails(observer)}" }

      mail(to: sender_mails(observer), subject: "Monitor is #{observer.events.last.event_type.upcase}: #{observer.name.upcase}")
    end
  end

  private
  def sender_mails observer
    observer.observer_senders.where(enable: true).map do |observer_sender|
      observer_sender.sender.email
    end.uniq.compact
  end
end
