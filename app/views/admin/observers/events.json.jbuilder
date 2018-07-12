json.draw params[:draw].to_i
json.recordsTotal observer_events.count
json.recordsFiltered @result_count

json.data @result.map do |event|
  json.array! [
    observer_event_type_tag(event.event_type),
    l(event.created_at, format: :ymds),
    observer_event_reason(event.reason),
    observer_event_duration_at(event),
  ]
end
