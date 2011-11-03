layout =

  set_notification_count: ->
    count = $('#notificationsCountValue').text()
    if (Number) count > 0
      $('.notificationsCountWrapper').show()
    return false

  toggle_wall_and_info: (e) ->
    e.preventDefault()
    el = e.target.id
    showing = $('.' + el, '#profile').is(":visible")
    if showing == false
      $('.section').each( ->
        $(this).fadeOut('fast')
      )
      $('.' + el, '#profile').fadeIn('fast')


window.layout = exports ? layout