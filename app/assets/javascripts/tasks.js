var ready, set_positions;

set_positions = function(){
  $('.ui-state-default').each(function(i){
    $(this).attr("data-pos",i+1);
  });
}

ready = function(){
  set_positions();
  $('.sortable').sortable();
  $('.sortable').sortable().bind('sortupdate', function(e, ui) {
    updated_order = []
    set_positions();
    $('.ui-state-default').each(function(i){
      updated_order.push({ id: $(this).data("id"), position: i+1 });
    });

    $.ajax({
      type: "PUT",
      url: '/tasks/sort',
      data: { order: updated_order }
    });
  });
}

$(document).ready(ready);
$(document).on('page:load', ready);