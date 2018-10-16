$(document).ready(function(e){
	$('body').on('cocoon:after-remove', function(e, insertedItem) {
   	$('body').find('input#submit_tag')[0].click()
  });

  
  $('body').on('click', '#delete_button', function(e) {
    $(this).prev().val(1)
    $('body').find('input#submit_tag')[0].click()
    
  });
  $('body').on('change', '.check-box', function(e) {
    $('body').find('input#submit_tag')[0].click()
  });

  $('body').on('focusout', '.title, .new-title, .thought-area', function(e) {
    $('body').find('input#submit_tag')[0].click()
  });

  $('body').on('click', '#add_thoughts', function(e){
  	// debugger
    // $('.summernote').summernote({
    //   height: 100,
    // width: 100,
    //   toolbar: [['style', ['bold', 'italic', 'underline', 'clear']]]
    // });
  })



  $(function(){
    $("a.add-thoughts")
      .on('cocoon:before-insert', function () {
          console.log('before insert');
      })
      .on('cocoon:after-insert', function () {
          console.log('after insert');
      })
      .on("cocoon:before-remove", function () {
          console.log('before remove');
      })
      .on("cocoon:after-remove", function () {
          console.log('after remove');
      });

   $("a.add-thoughts").on('click', function(){
     console.log('looks like clicking works...');
   });
});
});

// $(function() {
//   $('.sortable').railsSortable();
// });