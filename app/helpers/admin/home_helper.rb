module Admin::HomeHelper
  def is_observer_page?
    controller_name == 'observers'
  end
end
