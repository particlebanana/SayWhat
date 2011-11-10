$ ->

  @layout = window.layout

  @layout.set_notification_count()
  $('header').dropdown()
  $('#admin_header').dropdown()
  $(".alert-message").alert('close')

  $('.grid').masonry
    itemSelector : '.section',
    columnWidth : 462