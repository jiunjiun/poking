module Admin::HomeHelper
  def is_dashboard?
    controller_name == 'home' and action_name == 'index'
  end
end
