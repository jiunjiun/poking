module Admin::ProfilesHelper
  def profile_active_tab class_type
    if flash[:active_tab] == class_type
      'show active'
    else
      ''
    end
  end
end
