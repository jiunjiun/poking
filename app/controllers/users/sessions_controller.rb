class Users::SessionsController < Devise::SessionsController
  layout 'sign'
  before_action :update_meta, only: [:new]

  def new
    self.resource = resource_class.new(sign_in_params)
    store_location_for(resource, admin_root_path)
    super
  end

  private
  def update_meta
    meta_tags_option = {
      site: I18n.t('sign_in'),
    }

    prepare_meta_tags meta_tags_option
  end
end
