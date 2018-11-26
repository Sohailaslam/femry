// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require cocoon
// require turbolinks
//= require jquery-ui
//= require jquery.ui.touch-punch.min
//= require popper.min
//= require bootstrap.min
//= require bootstrap-pincode-input
//= require lc_switch
//= require parsley
//= require custom
// require ckeditor/init
//= require js.cookie
//= require jstz
//= require browser_timezone_rails/set_time_zone
//= require circliful.min
//= require trix
//= require jquery.remotipart
//= require Chart.bundle
//= require chartkick
//= require moment
//= require daterangepicker

$(document).ready(function(){
  var tagAutocompleter = $.MentionsKinder.Autocompleter.Select2Autocompleter.extend({
    select2Options: {
      tags: JSON.parse($('#rails_tags').attr('data-tags'))
    }
  });
  
 $('.tags').mentionsKinder({
    trigger: {
      '#': {
        triggerName: 'tag',
        autocompleter: tagAutocompleter
      }
    }
  })
});