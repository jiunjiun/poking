class Admin::ProfilesController < AdminController
  def edit
  end

  def update
    if current_user.update user_params
      redirect_to edit_admin_profiles_path, notice: t('helpers.successfully_created')
    else
      redirect_to edit_admin_profiles_path, alert: current_user.errors.full_messages.join
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :time_zone)
  end
end
