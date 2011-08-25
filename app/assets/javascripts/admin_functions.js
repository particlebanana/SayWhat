$(document).ready(function() {
	$('a[rel*=facebox]').facebox()
	manageDropDown();
});

function build_dynamic_url(url, queryString) {
	base = url.split('?');
	return base[0] + '?reason=' + queryString
}