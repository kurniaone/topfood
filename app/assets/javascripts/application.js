// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.facebox
//= require autocomplete-rails
//= require_tree .

$(document).ready(function(){
  if($.fn.facebox){
    $('a[rel*=facebox]').facebox();
  }

  // datepicker
  if ($.fn.datepicker){
    $('.datepicker').datepicker({
      dateFormat: 'dd-mm-yy'
    }).attr('readonly', 'readonly');
    if ($('.datepicker.now').val() == '') $('.datepicker.now').datepicker('setDate', new Date());
    $('.datepicker.min-now').datepicker('option', 'minDate', new Date());
  }

  // chosen
  if ($.fn.chosen){
    $('.chzn-select').chosen();
  }

  // hide flash by click on it
  $('.flash').click(function(){
    $(this).slideUp();
  });

  // select/deselect all items
  $('.toggle-all').click(function(){
    var check = $(this).is(':checked');
    $('.table td input[type=checkbox]').attr('checked', check);
    toggle_on_change($(this));
  });

  $('.s-toggle').change(function(){
    toggle_on_change($(this));
  });


});

// enable / disable submit form
function toggle_on_change(elm){
  all_toggle = $('.s-toggle').length;
  checked_toggle = $('.s-toggle:checked').length;
  submit = $(elm).closest('form').find('input[type=submit]')[0];

  check = (all_toggle == checked_toggle);
  $('input.toggle-all').attr('checked', check);

  if(checked_toggle == 0){
    $(submit).attr('disabled', 'disabled');
  }else{
    $(submit).removeAttr('disabled');
  }
}

// remove fields
function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).parent().hide();
}

// add fields
function add_fields(link, association, content, el_id = '') {
  if(el_id == '') el_id = association;
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $('#'+el_id).append(content.replace(regexp, new_id));
}

// remove items
function remove_items(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).parent().parent().hide();
}

// add items
function add_items(link, association, content, el_id = '') {
  if(el_id == '') el_id = association;
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $('.table#'+association).append(content.replace(regexp, new_id));
}


$(function(){
  $("input.number").keydown(function(event){
    // Allow: backspace, delete, tab and escape
    if(event.keyCode == 46 || event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 27 || event.keyCode == 190 ||
       // Allow: Ctrl+A
      (event.keyCode == 65 && event.ctrlKey === true) ||
       // Allow: home, end, left, right
      (event.keyCode >= 35 && event.keyCode <= 39)) {
         // let it happen, don't do anything
        return;
    }else{
      // Ensure that it is a number and stop the keypress
      if ( event.shiftKey|| (event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105 ) ){
        event.preventDefault();
      }
    }
  });
});
