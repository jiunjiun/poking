class Admin::ObserverSendersController < AdminController
  expose :observers, -> { current_user.observers }
  expose :observer, scope: -> { observers }
  expose :observer_senders, -> { observer.observer_senders }
  expose :senders, -> { observer.observer_senders.where(enable: true) }
  expose :sender

  def edit
  end

  def update
    observer_senders.destroy_all

    if observer_senders.create observer_sender_params[:observer_senders_attributes]
      redirect_to edit_admin_observer_senders_path(observer), notice: t('helpers.successfully_created')
    else
      flash[:alert] = I18n.t('helpers.create_fail', message: observer_senders.errors.full_messages.join)
      render :new
    end
  end

  private
  def observer_sender_params
    params.require(:observer).permit(observer_senders_attributes: [:sender_id, :enable])
  end
end
