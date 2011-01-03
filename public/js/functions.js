head.ready(function() {
  
	// All Projects :nth-child selector (for use in IE)
	$(".projectsList li:nth-child(4n+1)").addClass("nthLeft");
	$('.projectsList li:nth-child(4n+4)').addClass("nthRight");

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