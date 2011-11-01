layout =

  set_notification_count: ->
    count = $('#notificationsCountValue').text()
    if (Number) count > 0
      $('.notificationsCountWrapper').show()
    return false

window.layout = exports ? layout