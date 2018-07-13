# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  if $('#observer_show_statistics').length
    chart1 = new Chart(document.getElementById('statistics-chart').getContext('2d'),
      type: 'line'
      data:
        labels: gon.chart.labels
        datasets: [
          {
            label: 'ms'
            data: gon.chart.data
            borderWidth: 2
            backgroundColor: '#4A81FD'
            borderColor: '#4A81FD'
            fill: false,
          }
        ]
      options:
        # title:
        #   display: true,
        #   text: 'Response Time by Last 24 hours'
        tooltips:
          mode: 'index'
          intersect: false
        hover:
          mode: 'nearest'
          intersect: true
        scales:
          xAxes: [ {
            gridLines: display: false
            ticks: fontColor: '#aaa'
          } ]
          yAxes: [ {
            gridLines: display: false
            ticks: fontColor: '#aaa'
          } ]
        responsive: true
        maintainAspectRatio: false)

  if $('#events-table').length
    columns = $.map $('#events-table th'), (i, j) -> {name: $(i).data('name')}

    table = $('#events-table').DataTable
      stateSave: false
      serverSide: true
      searching: false
      lengthMenu: [5, 10, 25]
      ajax:
        url: "#{window.location.pathname}/events.json"
        searchDelay: 500
      # language:
        # url: '/datatable.chinese_traditional.lang.json'
      columns: columns
      order: [1, 'desc']
      columnDefs:[
        {
          targets: [0, 1, 2, 3]
          className: "text-center"
        }
        {orderable: false, targets: [0, 2, 3]}
      ]
      initComplete: ( settings, json )->
        $('[data-toggle="tooltip"]').tooltip()
