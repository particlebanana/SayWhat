$(document).ready(function(){	
  
  // Manage display state for User avatar edit options
  if ( $('.avatarOptions').length > 0 ) {
    $('.avatarUpload').hide();
    $('#changeAvatar').click(function(){
      $('.avatarOptions').hide();
      $('.avatarUpload').show();
      return false;
    })
  } else {
    $('.avatarUpload').show();
  }

});