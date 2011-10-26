$ ->

  @timeline = window.timeline
  @uploader = window.uploader

  $('header').dropdown()
  $(".alert-message").alert('close')

  bindings =
    # Timeline Bindings
    $('#event_wrapper').delegate('a.comment_link', "click", @timeline.toggle_comment)
    $('.attachments_select').delegate('a', 'click', @timeline.show_composer_element)
    $('.timeline textarea.textInput').each (i,e) -> $(e).autoResize()
    $('#event_wrapper').delegate('textarea.textInput', 'keypress', @timeline.prevent_new_line)
    $('#event_wrapper').delegate('textarea.textInput', 'keyup', @timeline.submit_on_enter)
    $('#composer form').submit @timeline.create_attachment

    # Uploader Bindings
    $('.upload_select').delegate('a', 'click', @uploader.show_uploader)
    $('ul.photos').delegate('a.fancybox', 'hover', ->
      $(this).fancybox()
      return false
    )
    $('a.fancybox').fancybox()