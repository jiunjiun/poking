module Admin::ObserversHelper
  def rate_color rate
    if rate >= 80
      'text-success'
    else
      'text-danger'
    end
  end

  def observer_event_type_tag type
    case type
    when ObserverEvent::Type::UP
      content_tag(:div, type.upcase, class: 'badge badge-success')
    when ObserverEvent::Type::DOWN
      content_tag(:div, type.upcase, class: 'badge badge-danger')
    when ObserverEvent::Type::STARTED
      content_tag(:div, type.upcase, class: 'badge badge-default')
    when ObserverEvent::Type::PAUSED
      content_tag(:div, type.upcase, class: 'badge badge-default')
    end
  end

  def observer_event_reason reason
    if reason.length >= 20
      content_tag :div, truncate(reason, length: 20, separator: ' '), data: {toggle: 'tooltip', placement: 'top', title: reason}
    else
      reason
    end
  end

  def observer_event_duration_at event
    if event.duration_at.present?
      time_ago_in_words(Time.at(event.created_at.to_i - event.duration_at))
    else
      time_ago_in_words(event.created_at.to_i)
    end
  end
end
