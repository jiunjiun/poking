class AdminController < ApplicationController
  expose :observers, -> { current_user.observers }

  layout 'admin'

  before_action :authenticate_user!
  before_action :set_timezone
  before_action :update_meta

  private
  def set_timezone
    if current_user && current_user.time_zone
      Time.zone = current_user.time_zone
    end
  end

  def update_meta
    meta_tags_option = {
      site: I18n.t('backend'),
    }

    prepare_meta_tags meta_tags_option
  end
end
