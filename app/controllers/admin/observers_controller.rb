class Admin::ObserversController < AdminController
  expose :observers, -> { current_user.observers }
  expose :observer, scope: -> { observers }
  expose :interval_range, -> { intervals }

  def show
  end

  def new
  end

  def create
    if observer.save
      redirect_to admin_observer_path(observer), notice: t('helpers.successfully_created')
    else
      flash[:alert] = I18n.t('helpers.create_fail', message: observer.errors.full_messages.join)
      render :new
    end
  end

  def edit
  end

  def update
    if observer.update observer_params
      redirect_to admin_observer_path(observer), notice: t('helpers.successfully_updated')
    else
      flash[:alert] = I18n.t('helpers.update_fail', message: shop.errors.full_messages.join)
      render :edit
    end
  end

  def destroy
    observer.destroy
    redirect_to admin_root_path, notice: t('helpers.successfully_destroy')
  end

  def start
    observer.start!
    redirect_to admin_observer_path(observer), notice: t('helpers.successfully_updated')
  end

  def pause
    observer.paruse!
    redirect_to admin_observer_path(observer), notice: t('helpers.successfully_updated')
  end

  private
  def observer_params
    params.require(:observer).permit(:name, :observer_type, :interval, :url)
  end

  def intervals
    _intervals = []
    (1..120).each do |i|
      _intervals << [
        "#{i} minutes", i
      ]
    end

    (3..24).each do |i|
      _intervals << [
        "#{i} hours", (i*60)
      ]
    end

    _intervals
  end
end
