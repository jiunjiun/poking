class DeviserMailer < Devise::Mailer
  include AssetsHelper
  helper_method :inline_css

  layout 'devise_mailer'
end
