class AdminController < ApplicationController
  expose :observers, -> { current_user.observers }

  layout 'admin'

  before_action :authenticate_user!
  before_action :update_meta

  private
  def update_meta
    meta_tags_option = {
      site: I18n.t('backend'),
    }

    prepare_meta_tags meta_tags_option
  end
end
