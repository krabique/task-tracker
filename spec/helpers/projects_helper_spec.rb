# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ProjectsHelper. For example:
#
# describe ProjectsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ProjectsHelper, type: :helper do
  context '.link_to_task_with_status_color(text, path, status, user_id)' do
    it 'should return a link to task with the according css class on it' do
      task = create(:task)
      expect(
        link_to_task_with_status_color(
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
