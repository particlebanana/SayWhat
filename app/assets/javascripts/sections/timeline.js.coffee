timeline =

  show_composer_element: =>
    composer = $('#composer')
    $('.attachments_form', composer).removeClass 'hidden'
    return false

  toggle_comment: (e) =>
    form = $(e.currentTarget).closest('form')
    $('.comment_box', form).removeClass 'hidden'
    return false

  prevent_new_line: (e) =>
    if e.keyCode == 13 && !e.ctrlKey
      e.preventDefault()

  submit_on_enter: (e) =>
    if e.keyCode == 13 && !e.ctrlKey
      form = $(e.currentTarget).closest('form')
      $("input[type=submit]", form).addClass('disabled').attr('disabled', 'disabled')
      comment_box = $('li.comment_box', form)
      $('.wrap', comment_box).fadeOut('fast', ->
        $('.loader', comment_box).removeClass('hidden')
      )
      submit_from_subevent(form)

  create_attachment: (e) =>
    e.preventDefault()
    $("input[type=submit]", e.currentTarget).addClass('disabled').attr('disabled', 'disabled')
    $(".loader", e.currentTarget).removeClass('hidden')
    submit_from_composer(e)


submit_from_composer = (e) ->
  url = e.currentTarget.action
  data = $(e.currentTarget).serialize()
  $.ajax 
    url: url,
    type: 'post',
    dataType: 'json',
    data: data,
    dataType: 'json',
    success: (response) ->
      attachment = eval('(' + response + ')');
      group = attachment.event.objects.group

      if attachment.event.objects.hasOwnProperty "project"
        project = attachment.event.objects.project
        attachment.event.url = "/groups/#{group.id}/projects/#{project.id}/comments/#{attachment.event.key}/comments"
      else if attachment.event.objects.hasOwnProperty "group"
        attachment.event.url = "/groups/#{group.id}/comments/#{attachment.event.key}/comments"

      # Check if attachment form is the main composer or a sub event
      composer_parent = $(e.currentTarget).parent('ul.attachments_form')
      if $(composer_parent).length > 0
        $(composer_parent).addClass('hidden')

      $("input[type=submit]", e.currentTarget).removeClass('disabled').removeAttr('disabled')
      $("textarea", e.currentTarget).val('')
      $(".loader", e.currentTarget).addClass('hidden')

      $(JST['timeline/comment'](attachment.event)).hide().prependTo('#event_wrapper').fadeIn("fast")


submit_from_subevent = (form) ->
  console.log(form)
  url = form.attr('action')
  data = $(form).serialize()
  console.log(data)
  $.ajax 
    url: url,
    type: 'post',
    dataType: 'json',
    data: data,
    dataType: 'json',
    success: (response) ->
      attachment = eval('(' + response + ')');

      subevent = $('li.comment_box', form)

      $("input[type=submit]", form).removeAttr('disabled')
      $("textarea", form).val('').css('height', 14).blur()

      $(JST['timeline/inline_comment'](attachment.event)).hide().insertBefore(subevent).fadeIn("fast")

      comment_box = $('li.comment_box', form)
      $('.wrap', comment_box).fadeIn('fast', ->
        $('.loader').addClass('hidden')
      )

window.timeline = exports ? timeline