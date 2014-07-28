// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
	$( "#user_access_start_date_s" ).datepicker({dateFormat: 'yy-mm-dd'});
	$( "#user_access_end_date_s" ).datepicker({dateFormat: 'yy-mm-dd'});
});

$(function (){
	$('#user_access_engine_id').change(function(){
      $.get(window.location, $('form').serialize(), null, "script");
  	  return false;
	});
});