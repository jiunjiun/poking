class Admin::ProfilesController < AdminController
  def edit
    flash[:active_tab] = 'profile'
  end

  def update
    flash[:active_tab] = 'profile'

    if current_user.update user_params
      redirect_to edit_admin_profiles_path, notice: t('helpers.successfully_created')
    else
      redirect_to edit_admin_profiles_path, alert: current_user.errors.full_messages.join
    end
  end

  def update_password
    flash[:active_tab] = 'profile_password'

    if current_user.update_with_password user_password_params
      bypass_sign_in(current_user)
      redirect_to edit_admin_profiles_path, notice: t('helpers.successfully_updated')
    else
      render 'edit'
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :time_zone)
  end

  def user_password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
