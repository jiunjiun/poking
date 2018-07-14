module Admin::HomeHelper
  def is_observer_page?
    controller_name == 'observers' and observers.exists?
  end
end
