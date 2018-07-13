class Users::RegistrationsController < Devise::RegistrationsController
  layout 'sign'
  before_action :configure_sign_up_params, only: [:create]
  before_action :update_meta, only: [:new]

  def update
    if current_user.update_with_password user_params
      bypass_sign_in(current_user)
      redirect_to admin_root_path, notice: t('helpers.successfully_updated')
    else
      render :edit
    end
  end

  private
  def configure_sign_up_params
    attributes = [:username, :email]
    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
  end

  # def after_inactive_sign_up_path_for(resource)
  #   confirm_email_path
  # end

  def user_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

  def update_meta
    meta_tags_option = {
      site: I18n.t('sign_up'),
    }

    prepare_meta_tags meta_tags_option
  end
end
