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
//= require popper
//= require jquery-ui
//= require jquery_ujs
//= require bootstrap
//= require bootstrap-datetimepicker
//= require turbolinks
//= require Chart.bundle
//= require chartkick
//= require_tree .

$(document).on('turbolinks:load', function() {
  $('#sidebarCollapse').on('click', function () {
      $('#sidebar, #content').toggleClass('active');
      $('.collapse.in').toggleClass('in');
      $('a[aria-expanded=true]').attr('aria-expanded', 'false');
  });
});
$(document).ready(function() {
  return $('.datepicker').datetimepicker({
    autoclose: true,
    todayBtn: true,
    minView: 'day',
    autoclose: true,
    clearBtn: true,
    format: 'yyyy-mm-dd hh:00'
  });
});
// $(document).ready(function() {
//   $('#reported_at_date').datepicker({
//     clearBtn: true,
//     autoclose: true,
//     todayHighlight: true,
//     format: 'mm-yyyy'
//   });
// });
