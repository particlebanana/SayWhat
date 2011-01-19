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
	
	
	var tabs = $('ul#tabbedNav li');
	tabs.click(function(e){
		var element = $(this);
		var id = element.attr('id');
		
		if(element.find('.active').length) return false;
		
		tabs.each(function(){ $(this).removeClass('active'); });
		element.addClass('active');
			
		if(id == 'pinfo'){
			$('div#comments').fadeOut('fast', function(){
				$('div#info').fadeIn('fast');
			});
		} else if(id == 'pdiscussion') {
			$('div#info').fadeOut('fast', function(){
				$('div#comments').fadeIn('fast');
			});
		}
		return false;
	})
	
	// Datepicker
	$('#projectForm #startDate input').datepicker();
	$('#projectForm #endDate input').datepicker();

});