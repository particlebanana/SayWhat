layout =

  set_notification_count: ->
    count = $('#notificationsCountValue').text()
    if (Number) count > 0
      $('.notificationsCountWrapper').show()
    return false

  toggle_wall_and_info: (e) ->
    e.preventDefault()
    link = $(e.target).closest('a')
    el = $(link).attr('id')
    showing = $('.' + el, '#profile').is(":visible")
    section_count = $('.section').size()
    if showing == false
      $('.section').each (idx) ->
        $(this).fadeOut 'fast', ->
          if ((idx + 1) == section_count)
            $('.' + el, '#profile').fadeIn('fast')

window.layout = exports ? layout