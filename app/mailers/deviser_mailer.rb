class DeviserMailer < Devise::Mailer
  include ActionView::Helpers
  include AssetsHelper
  helper_method :inline_css

  layout 'devise_mailer'
end
