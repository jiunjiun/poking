class SystemMailer < ApplicationMailer
  default from: "services@#{Settings.domain.url}"

  def alert observer
    if observer.present?
      @observer = observer

      mail(to: sender_mails(observer), subject: 'title')
    end
  end

  private
  def sender_mails observer
    observer.observer_senders.where(enable: true).map do |observer_sender|
      observer_sender.sender.email
    end
  end
end
