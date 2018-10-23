$(document).ready(function(e){

  multiline_support();
  $('body').on('cocoon:after-remove', function(e, insertedItem) {
    $('body').find('input#submit_tag')[0].click()
  });

  $('body').on('cocoon:before-remove', function(event, insertedItem) {
    // debugger
    // $('#myModal').modal("show");
     // event.preventDefault();
    // var confirmation = confirm("Are you sure?");
    // if( confirmation === false ){
    //   event.preventDefault();
    // }
  });

  $('body').on('click', '#delete_button', function(e){
    previous_destroy_field = $(this).prev().attr("id");
    timer = setTimeout( function(){ 
      $('#'+previous_destroy_field).val(1)
      $('body').find('input#submit_tag')[0].click()
      $('#myModal').modal("hide")
    }  , 5000 );

    $('#undo').click(function(event){
      clearTimeout(timer);
      e.preventDefault()
    })
  })

  $('body').on('keyup', 'textarea', function(e){
    while($(this).outerHeight() < this.scrollHeight + parseFloat($(this).css("borderTopWidth")) + parseFloat($(this).css("borderBottomWidth"))) {
      $(this).height($(this).height()+1);
    };
  })

  
  CKEDITOR.on( 'instanceReady', function( evt ) {
    var editor = evt.editor,
      body = CKEDITOR.document.getBody();
      $('div#thoughts').find('.cke_top').addClass('d-none')
      $('div#thoughts').find('.cke_bottom').addClass('d-none')
      $('div#thoughts').find('.new-thought-box').find('.cke_top').removeClass('d-none')
    editor.on( 'focus', function(e) {
      data_id = e.editor.element.getAttribute('data-id')
      $('.thoughts_'+data_id).find('.cke_top').removeClass('d-none')
      $('.thoughts_'+data_id).find('.cke_bottom').removeClass('d-none')
      $('.st_'+data_id).removeClass('d-none')
    });    
  } );

  // $('body').on('click', '#delete_thought_button', function(e) {
  //   thought_id = $(this).attr('data-id')

  //   $.ajax({
  //     url: '/thoughts/'+thought_id,
  //     method: "DELETE",
  //     success: (function(_this) {
  //     })(this)
  //   });
  // });

  // $('body').on('click', '#delete_button', function(e) {
  //   $(this).prev().val(1)
  //   $('body').find('input#submit_tag')[0].click()
    
  // });
  $('body').on('change', '.check-box', function(e) {
    $('body').find('input#submit_tag')[0].click()
  });

  $('body').on('focusout', '.title, .new-title', function(e) {
    debugger
    $('body').find('input#submit_tag')[0].click()
  });

  $('body').on('click', '#add_new_thoughts', function(e) {
    data_id = $(this).attr('data-id')
    $(this).addClass('d-none')
    $('.st_'+data_id).removeClass('d-none')
  });

  $('body').on('click', '#edit_thoughts', function(e) {
    data_id = $(this).attr('data-id')
    $('.thoughts_'+data_id).find('.cke_top').removeClass('d-none')
    $('.thoughts_'+data_id).find('.cke_bottom').removeClass('d-none')
    $(this).addClass('d-none')
    $('.st_'+data_id).removeClass('d-none')
  });

  $('body').on('click', '#save_thoughts', function(e) {
    data_id = $(this).attr('data-id')
    $(this).addClass('d-none')
    $('.et_'+data_id).removeClass('d-none')
    $('body').find('input#submit_tag')[0].click()
    
  });

  // $('body').on('focusin', '.cke_contents', function(e) {
  //   debugger
  //   $('div#thoughts').find('.cke_top').removeClass('d-none')
  //   $('div#thoughts').find('.cke_bottom').removeClass('d-none')
  //   $(this).addClass('d-none')
  //   $('#edit_thoughts').addClass('d-none')
  //   $('#save_thoughts').removeClass('d-none')
  // }); 

  if ($('#infinite-scrolling').size() > 0) {
    return $(window).on('scroll', function() {
      // var more_posts_url;
      // more_posts_url = $('.pagination .next_page a').attr('href');
    setTimeout( function(){ 
      if ($(window).scrollTop() > ($(document).height() - $(window).height()) * 0.95 )  {
        $('.loader').removeClass('d-none');
        $.ajax({
          type:'GET', 
          url: '/',
          data: {page: $('.loader').attr('data-page')},
          success: function(result) {
            $('.loader').addClass('d-none');
          }
        });
      }
    }  , 2000 );
      return;
    });
  }
});

function multiline_support(){
  $( "textarea.title" ).each(function( index ) {
    while($(this).outerHeight() < this.scrollHeight + parseFloat($(this).css("borderTopWidth")) + parseFloat($(this).css("borderBottomWidth"))) {
      $(this).height($(this).height()+1);
    };
  });
}
