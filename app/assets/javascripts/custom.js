var a_href; 

$(document).ready(function(e){
  $('.thought-area').blur()
  multiline_support();
  initialize_ckeditor();
  initialize_progress_loader();

  $('input[name="daterange"]').daterangepicker({
    autoApply: true,
    startDate: moment().subtract(29, 'days').format("MMMM DD, YYYY"),
    endDate: moment().format("MMMM DD, YYYY"),
    "locale": {
      "format": "MMMM DD, YYYY"
    },
  });

  $('input[name="daterange"]').on('apply.daterangepicker', function(ev, picker) {
    $(this).val(picker.startDate.format('MMMM DD, YYYY') + ' - ' + picker.endDate.format('MMMM DD, YYYY'));
    $('#date_range_form').submit();
  });
  
  $('body').on('click', '#delete_button, #delete_thought_button', function(e){
    e.preventDefault();
    $('.undo-alert').addClass("d-none")
    $('.undo-alert').removeAttr("style")
    $('.undo-alert').stop().fadeTo("fast", 1);

    task_id = $(this).closest('li.nested-fields').attr('data-id')
    
    button_type = (($(this).attr('id') == "delete_thought_button") ? 'thought' : 'task' )
    
    $.ajax({
      url: '/todos/update_deleted_column',
      method: "POST",
      data: {id: task_id, button_type: button_type, button_action: 'make_inactive'},
      success: (function(result) {
      })
    });

    if ($(this).attr('id') == "delete_thought_button") {
      $('.undo-alert').find('span').text('thought')
      data_id = $(this).parents('div#thoughts').attr('class').split('_')[1]
      $('.ant_'+data_id).removeClass('d-none')
      $(".st_"+data_id).addClass('d-none');
    } else {
      $('.undo-alert').find('span').text('to-do')
    }

    $('.undo-alert').removeClass("d-none")


    
    previous_destroy_field = $(this).prev().attr("id");

    li_id = $(this).closest('li.nested-fields').attr('id')
    
    task_id = $(this).closest('li.nested-fields').attr('data-id')
    $(this).closest('li.nested-fields').addClass('d-none').removeClass('add-task-box')

    if ($(this).attr('id') == "delete_thought_button"){
      // data_id = $(this).parents('div#thoughts').attr('class').split('_')[1]
      // $('.ant_'+data_id).removeClass('d-none')
      // $("st_"+data_id).addClass('d-none');
      if ($(this).parents('li.add-thougt-box:visible').length < 1){
        $(this).parents('.todos-list').find('div#thoughts li').addClass('bt-0')
      }

    } else {
      if ($(this).parents('ul.sortable').find('li.add-task-box:visible').length < 1){
        $(this).parents('.todos-list').find('div#thoughts li:visible').addClass('bt-0')
      }
      $(this).parents('.todos-list').find('ul.sortable li:visible').first().removeClass('bt-1')
    }
    if ($(this).attr('id').includes("thought")) {
      timer = setTimeout( function(){ 
        $('#'+previous_destroy_field).val(1)
        // $('.undo-alert').fadeTo(3000, 0.01, function(){ 
          $('.undo-alert').slideUp(500, function() {
            $(this).addClass("d-none")
            $(this).removeAttr('style');
            
            $('#'+li_id).remove();
          }); 
        // });
        $.ajax({
          url: '/thoughts/'+task_id,
          method: "DELETE",
          success: (function(result) {
          })
        });
      }  , 5000 );
    }
    else {
      timer = setTimeout( function(){ 
        $('#'+previous_destroy_field).val(1)
        
        // $('.undo-alert').fadeTo(3000, 0.01, function(){ 
          $('.undo-alert').slideUp(500, function() {
            $(this).addClass("d-none")

            $(this).removeAttr('style');
          }); 
          $('#'+li_id).closest('ul').find('li.d-none').remove()
        // });
        // $.ajax({
        //   url: '/tasks/'+task_id,
        //   method: "DELETE",
        //   success: (function(result) {
        //   })
        // });
      }  , 5000 );
    }

    $('body').on('click', '#undo', function(e){
      $.ajax({
        url: '/todos/update_deleted_column',
        method: "POST",
        data: {id: task_id, button_type: button_type, button_action: 'make_active'},
        success: (function(result) {
          $('#'+li_id).removeClass('d-none').addClass('add-task-box');
          clearTimeout(timer);
          $('.undo-alert').addClass("d-none")
          $('.ant_'+data_id).addClass('d-none')
          e.preventDefault()
        })
      });
    })

  })

  // $('body').on('keyup', 'textarea', function(e){
  //   debugger
  //   while($(this).outerHeight() < this.scrollHeight + parseFloat($(this).css("borderTopWidth")) + parseFloat($(this).css("borderBottomWidth"))) {
  //     $(this).height($(this).height()+1);
  //   };
  // })

  
  $('body').on('change', '.check-box', function(e) {
    task_id = $(this).closest('li.nested-fields').attr('data-id')
    status = $(this).is(":checked") ?  1 : 0
    $.ajax({
      type:'PUT', 
      url: '/tasks/'+task_id,
      data: {task: {status: status}},
      success: function(result) {
      }
    });
  });

  $('body').on('focusout', '.title', function(e) {
    next_task = ((e.originalEvent.relatedTarget === null) ? null : e.originalEvent.relatedTarget.offsetParent.id)
    if ($('#select2-drop').length == 0 && $(this).prev('textarea').val() != "#" && $(this).prev('textarea').val() != "" && $(this).prev('textarea').val() !== undefined) {
      task_id = $(this).closest('li.nested-fields').attr('data-id')
      $.ajax({
        type:'PUT', 
        url: '/tasks/'+task_id,
        data: {task: {title: $(this).prev('textarea').val()}, next_task: next_task},
        success: function(result) {
        }
      });
    } else {
      e.preventDefault();
    }
  });


  $('body').on('keydown', '.title', function(e) {
    if(e.keyCode == 13) {
      e.preventDefault();
      date_key = $(this).parents('li.nested-fields').find('#task_date').val()
      $('.task_'+ date_key).click();
    }
  })

  $('body').on('focusout', '.new-title', function(e) {
    $('body').find('input#submit_tag')[0].click()
  });


  $('body').on('click', '#add_new_thoughts', function(e) {
    $('.undo-alert').addClass("d-none")
    $('.undo-alert').removeAttr("style")
    $('.undo-alert').stop().fadeTo("fast", 1);
    data_id = $(this).attr('data-id')
    $(this).addClass('d-none')
    $('.st_'+data_id).removeClass('d-none')
  });

  $('body').on('click', '#save_thoughts', function(e) {
    data_id = $(this).attr('data-id')
    $(this).addClass('d-none')
    $('.thoughts_'+data_id).find('.cke_top').addClass('d-none')
    $('.thoughts_'+data_id).find('.cke_bottom').addClass('d-none')
    $('.et_'+data_id).removeClass('d-none')
    thought_id = $('.thoughts_'+data_id).find('input#hidden_thought_'+data_id).val()
    thought_text = $('.thoughts_'+data_id).find('#thought_title_'+data_id).val()
    
    if ($('.new-thought-area').length > 0){
      $('body').find('input#submit_tag')[0].click()
    }
    else {
      $.ajax({
        type:'PUT', 
        url: '/thoughts/'+thought_id,
        data: {title: thought_text},
        success: function(result) {
        }
      });
    }

  });

  if ($('#infinite-scrolling').size() > 0) {
    return $(window).on('scroll', function() {
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

// function loadEditor(id){
//   var instance = CKEDITOR.instances[id];
//   if(instance)
//   {
//       CKEDITOR.remove(instance);
//   }
//   CKEDITOR.disableAutoInline = true;
//   CKEDITOR.inline( id);
// }

function initialize_progress_loader(){
  $('.progress-loader').circliful({
    animationStep: 5,
    foregroundBorderWidth: 70,
    backgroundBorderWidth: 70,
    foregroundColor: '#5fb760',
    backgroundColor: '#ededed',
    noPercentageSign: true,
    fontColor: '#fff'
  });
}

function initialize_ckeditor(){
  $(document).on("trix-initialize", function(event) {
    // $('trix-editor').focus()
  });
  document.addEventListener("trix-focus", function(event) {
    var toolbar, toolbar_id;
    toolbar_id = event.target.getAttribute('toolbar');
    toolbar = document.getElementById(toolbar_id);
    toolbar.style.display = 'block';
    data_id = event.target.getAttribute('id').split('_')[1]
    $('.st_'+data_id).removeClass('d-none')
    $('.ant_'+data_id).addClass('d-none')
  });

  document.addEventListener("trix-blur", function(event) {
    if (event.currentTarget.activeElement.id == "delete_thought_button"){
      $('.st_'+data_id).addClass('d-none')
      event.preventDefault();
    } else if (event.currentTarget.activeElement.className  == "trix-input trix-input--dialog") {
      event.preventDefault();
    } else {
      var toolbar, toolbar_id;
      toolbar_id = event.target.getAttribute('toolbar');
      toolbar = document.getElementById(toolbar_id);
      toolbar.style.display = 'none';
      data_id = event.target.getAttribute('id').split('_')[1]
      editor_text = document.querySelector("trix-editor#"+event.target.getAttribute('id')).value
      $('#thought_title_'+data_id).val(editor_text)
      $('.st_'+data_id).click();
    }
  });

}

function initializeAutocompleter(task_id, tagAutocompleter) {
  $('li#task_'+task_id).find('.tags').mentionsKinder({
    trigger: {
      '#': {
        triggerName: 'tag',
        autocompleter: tagAutocompleter
      }
    }
  })
}

// function getCaretPosition(editableDiv) {
//   var caretPos = 0,
//     sel, range;
//   if (window.getSelection) {
//     sel = window.getSelection();
//     if (sel.rangeCount) {
//       range = sel.getRangeAt(0);
//       if (range.commonAncestorContainer.parentNode == editableDiv) {
//         caretPos = range.endOffset;
//       }
//     }
//   } else if (document.selection && document.selection.createRange) {
//     range = document.selection.createRange();
//     if (range.parentElement() == editableDiv) {
//       var tempEl = document.createElement("span");
//       editableDiv.insertBefore(tempEl, editableDiv.firstChild);
//       var tempRange = range.duplicate();
//       tempRange.moveToElementText(tempEl);
//       tempRange.setEndPoint("EndToEnd", range);
//       caretPos = tempRange.text.length;
//     }
//   }
//   return caretPos;
// }

$('[data-toggle="tooltip"]').tooltip()