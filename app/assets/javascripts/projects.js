$(document).ready(function () {
  $('#current-user-task-filter-checkbox:checkbox').click(function () {
    if ($('input:checkbox:checked').length) {
      $('#projects-tasks-list').find('a').hide();
      $("#projects-tasks-list").find('a').each(function () {
        $('a[data-user-id*="' + $('#current-user-task-filter-checkbox')
          .data('user-id') + '"]').show();
      });
    } else {
      $("#projects-tasks-list").find('a').show();
    }
  });
});
