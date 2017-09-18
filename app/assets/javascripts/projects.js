$(document).ready( function(){
  $('#form-users-list-search').on('keyup', function() {
  var query = this.value.toLowerCase();
    $('.form-users-list-item').each(function(i, elem) {
      if (elem.id.toLowerCase().indexOf(query) != -1) {
          $(this).parent().css("display", "table-row");
      }else{
          $(this).parent().css("display", "none");
      }
    });
  });  
});
