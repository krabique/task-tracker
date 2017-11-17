# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsHelper, type: :helper do
  describe '.link_to_task_with_status_color(text, path, status, user_id)' do
    it 'should return a link to task with the according css class on it' do
      task = create(:task)
      expect(
        helper.link_to_task_with_status_color(
          task.title,
          project_task_path(task.project, task),
          task.status,
          task.user_id
        )
      ).to eq '<a ' \
              "class=\"list-group-item status-#{task.status}\" " \
              "data-user-id=\"#{task.user.id}\" " \
              "href=\"#{project_task_path(task.project, task)}\">" \
              "#{task.title}" \
              '</a>'
    end
  end
end
