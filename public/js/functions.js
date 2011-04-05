head.ready(function() {
	
	$('video').mediaelementplayer();
	
	manageDropDown();	
	
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

/* Based on the method used by Twitter */
/* http://davidwalsh.name/twitter-dropdown-jquery */
function manageDropDown() {
	var activeClass = 'active', showingDropdown, showingMenu, showingParent;

	var hideMenu = function() {
		if(showingDropdown) {
			showingDropdown.removeClass('active');
			showingDropdown.css('top', '-999px');
		}
	};

	$('#session span').each(function(){
		var dropdown = $('#session .dropdown');
	  var parent = $('#session .relative');
		var clickArea = $(this);

	  var showMenu = function() {
	    hideMenu();
	    showingDropdown = dropdown.addClass('active');
	    showingDropdown.css('top', '36px');
	    showingParent = parent;
	  };
		
		$(clickArea).bind('click',function(e) {
			if(e) e.stopPropagation();
		  if(e) e.preventDefault();
		  showMenu();
		});
		
		$(clickArea).bind('focus',function() {
			showMenu();
		});
	})

	$(document.body).bind('click',function(e) {
		if(showingParent) {
			var parentElement = showingParent[0];
	    if(!$.contains(parentElement,e.target) || !parentElement == e.target) {
				hideMenu();
			}
		}
	});	
}