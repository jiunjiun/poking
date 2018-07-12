class SystemMailer < ApplicationMailer
  default from: "services@#{Settings.domain.url}"

  def alert observer
    if observer.present?
      @observer = observer
      sender_mails = observer.senders.pluck(:email)

      mail(to: sender_mails, subject: 'title')
    end
  end
end
