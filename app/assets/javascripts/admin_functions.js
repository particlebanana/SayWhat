$(document).ready(function() {
	$('a[rel*=facebox]').facebox()
	manageDropDown();
	
	// Isotope Functions
	
	// switches selected class on buttons
  $('#sort').find('li a').click(function(){
    var $this = $(this);
    // don't proceed if already selected
    if ( !$this.hasClass('selected') ) {
      $this.parents('#sort').find('.selected').removeClass('selected');
      $this.addClass('selected');
    }
  });
  
	/*
	  Tables
	*/
	var $userContainer = $('#usersTable .table'),
	    $groupContainer = $('#groupsTable .table');
	
	// Users Table 
	
  $('.userSort a').click(function(){
    var elem = $(this),
        container = $userContainer;
    sort(elem, container);
    return false;
  });
    
	$userContainer.isotope({
	  itemSelector: '.tr',
	  layoutMode: 'straightDown',
	  getSortData: {
	    name: function ( $item ) {
	      return $item.find('.user_name').text();
	    },
	    group: function ( $item ) {
	      return $item.find('.user_group').text();
	    },
	    role: function ( $item ) {
	      return $item.find('.user_role').text();
	    }
	  }
	});
	
	// Groups Table 
	
  $('.groupSort a').click(function(){
    var elem = $(this),
        container = $groupContainer;
    sort(elem, container);
    return false;
  });
    
	$groupContainer.isotope({
	  itemSelector: '.tr',
	  layoutMode: 'straightDown',
	  getSortData: {
	    name: function ( $item ) {
	      return $item.find('.group_name').text();
	    },
	    status: function ( $item ) {
	      return $item.find('.group_status').text();
	    }
	  }
	});
	
});

function build_dynamic_url(url, queryString) {
	base = url.split('?');
	return base[0] + '?reason=' + queryString
}

function sort(elem, container) {
  var $this = elem,
      $container = container,
      sortName = $this.attr('href').slice(1);
  $container.isotope({ 
    sortBy : sortName
  });
}