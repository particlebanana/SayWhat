$(document).ready(function() {
  
	$('p.buttons a.next').click(function(){
		var nextStep = $(this).attr('rel');
		$('.step:visible').fadeOut('fast', function(){
			$('#' + nextStep).fadeIn('fast');
		});
		return false;
	});
	
	$('p.buttons a.prev').click(function(){
		var prevStep = $(this).attr('rel');
		$('.step:visible').fadeOut('fast', function(){
			$('#' + prevStep).fadeIn('fast');
		});
		return false;
	});

});