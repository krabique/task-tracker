# frozen_string_literal: true

module ProjectsHelper
  def link_to_task_with_status_color(text, path, status, user_id)
    link_to(text, path, class: "list-group-item #{'status-' + status}", "data-user-id": user_id)
  end
end
