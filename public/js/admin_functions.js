$(document).ready(function() {
	$('a#deny').facebox();
});

function build_dynamic_url(url, queryString) {
	base = url.split('?');
	return base[0] + '?reason=' + queryString
}