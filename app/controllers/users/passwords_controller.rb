class Users::PasswordsController < Devise::PasswordsController

  before_action :update_meta, only: [:new]

  def update_meta
    meta_tags_option = {
      site: I18n.t('forgot_password'),
    }

    prepare_meta_tags meta_tags_option
  end
end
