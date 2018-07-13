class Admin::SendersController < AdminController
  expose :senders, -> { current_user.senders }
  expose :sender, build: ->(sender_params, scope){ scope.build(sender_params) }, scope: -> { current_user.senders }

  def index
  end

  def new
  end

  def create
    if sender.save
      redirect_to admin_senders_path, notice: t('helpers.successfully_created')
    else
      flash[:alert] = I18n.t('helpers.create_fail', message: sender.errors.full_messages.join)
      render :new
    end
  end

  def edit
  end

  def update
    if sender.update sender_params
      redirect_to admin_senders_path, notice: t('helpers.successfully_updated')
    else
      flash[:alert] = I18n.t('helpers.update_fail', message: sender.errors.full_messages.join)
      render :edit
    end
  end

  def destroy
    sender.destroy
    redirect_to admin_senders_path, notice: t('helpers.successfully_destroy')
  end

  private
  def sender_params
    params.require(:sender).permit(:name, :email)
  end
end
