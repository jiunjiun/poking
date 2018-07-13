class Users::PasswordsController < Devise::PasswordsController

  layout 'sign', only: [:edit]

  before_action :update_meta, only: [:new]

  private
  def update_meta
    meta_tags_option = {
      site: I18n.t('forgot_password'),
    }

    prepare_meta_tags meta_tags_option
  end
end
