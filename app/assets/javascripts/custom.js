$(document).ready(function(e){
	$('body').on('cocoon:after-remove', function(e, insertedItem) {
   	$('body').find('input#submit_tag')[0].click()
  });
})