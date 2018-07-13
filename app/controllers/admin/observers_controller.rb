class Admin::ObserversController < AdminController
  expose :observers, -> { current_user.observers }
  expose :observer, scope: -> { observers }
  expose :observer_events, -> { observer.events }
  expose :observer_senders, -> { observer.observer_senders.where(enable: true) }
  expose :interval_range, -> { intervals }
  expose :statistics, -> { observer.statistics }

  before_action :setup_gon, only: [:show]

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
      flash[:alert] = I18n.t('helpers.update_fail', message: observer.errors.full_messages.join)
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

  def events
    respond_to do |format|
      format.xlsx
      format.json {
        events_scope
        # events_filters
        events_order
      }
    end
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

  def events_scope
    @result = observer_events
  end

  def events_filters
    search_params = params[:search][:value]

    if search_params.present?
      search_params = "%#{search_params}%"
      @result       = @result.where("name like ? or
                                     barcode like ?",
                                     search_params, search_params, search_params)
    end
  end

  def events_order
    column_name = params[:columns][params[:order]["0"][:column]][:name]
    order       = params[:order]["0"][:dir]

    if column_name.present? and order.present?
      @result = @result.order("#{column_name} #{order}")
    else
      @result = @result.order(created_at: :desc)
    end

    @result_count = @result.count
    @result       = @result.offset(params[:start]).limit(params[:length])
  end

  def setup_gon
    labels = []
    data = []
    observer.lastday_records.each do |event|
      next unless event.response_time
      labels << event.created_at.strftime('%H:%M')
      data << (event.response_time * 1000).to_i
    end

    gon.chart = {
      labels: labels,
      data: data,
    }
  end
end
