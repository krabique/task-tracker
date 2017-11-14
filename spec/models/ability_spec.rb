# frozen_string_literal: true

require 'rails_helper'

require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  context 'a user with' do
    context 'anonymous user' do
      subject(:ability) { Ability.new(user, nil) }
      let(:user) { nil }

      it { is_expected.to be_able_to(:read, :all) }
      it { is_expected.to_not be_able_to(:filter_tasks, Project) }
    end

    context 'manager role' do
      subject(:ability) { Ability.new(user, project) }
      let(:user) { create(:manager) }

      context 'on his own project' do
        let(:project) { create(:project, user: user) }
        let(:task) { create(:task, project: project) }
        let(:comment) { create(:comment, task: task) }

        it { is_expected.to be_able_to(:read, :all) }
        it { is_expected.to be_able_to(:manage, project, user_id: user.id) }
        it {
          is_expected.to be_able_to(:manage, task,
                                    project: { user_id: user.id })
        }
        it {
          is_expected.to be_able_to(:manage, comment,
                                    task: { project: { user_id: user.id } })
        }
        it { is_expected.to_not be_able_to(:filter_tasks, Project) }
      end

      context 'not on his own project' do
        let(:project) { create(:project) }
        let(:task) { create(:task, project: project) }
        let(:comment) { create(:comment, task: task) }

        it { is_expected.to be_able_to(:read, :all) }
        it { is_expected.to_not be_able_to(:manage, project, user_id: user.id) }
        it {
          is_expected.to_not be_able_to(:manage, task,
                                        project: { user_id: user.id })
        }
        it {
          is_expected.to_not be_able_to(:manage, comment,
                                        task: { project: { user_id: user.id } })
        }
        it { is_expected.to_not be_able_to(:filter_tasks, Project) }
      end
    end

    context 'developer role' do
      subject(:ability) { Ability.new(user, project) }
      let(:user) { create(:developer) }

      context 'on a project that he is a member of' do
        let(:project) { create(:project, users: [user]) }
        let(:task) { create(:task, project: project) }
        let(:comment) { create(:comment, task: task) }

        it { is_expected.to be_able_to(:filter_tasks, Project) }
        it { is_expected.to_not be_able_to(:assign_user_to_task, task) }

        it { is_expected.to be_able_to(:new, Task) }
        it { is_expected.to be_able_to(:create, Task) }

        it { is_expected.to be_able_to(:new, Comment) }
        it { is_expected.to be_able_to(:create, Comment) }

        context 'on the task he has been assigned to' do
          let(:task) { create(:task, project: project, user: user) }

          it { is_expected.to be_able_to(:edit, task, user_id: user.id) }
          it { is_expected.to be_able_to(:update, task, user_id: user.id) }
        end

        context "on someone else's task" do
          let(:task) { create(:task, project: project) }

          it { is_expected.to_not be_able_to(:edit, task, user_id: user.id) }
          it { is_expected.to_not be_able_to(:update, task, user_id: user.id) }
        end

        context 'for his own comments' do
          let(:comment) { create(:comment, task: task, user: user) }

          it { is_expected.to be_able_to(:edit, comment, user_id: user.id) }
          it { is_expected.to be_able_to(:update, comment, user_id: user.id) }
          it { is_expected.to be_able_to(:destroy, comment, user_id: user.id) }
        end

        context "for the other's comments" do
          it { is_expected.to_not be_able_to(:edit, comment, user_id: user.id) }
          it {
            is_expected.to_not be_able_to(:update, comment, user_id: user.id)
          }
          it {
            is_expected.to_not be_able_to(
              :destroy, comment, user_id: user.id
            )
          }
        end
      end

      context 'not on a project that he is a member of' do
        let(:project) { create(:project) }
        let(:task) { create(:task, project: project) }
        let(:comment) { create(:comment, task: task) }

        it { is_expected.to be_able_to(:filter_tasks, Project) }
        it { is_expected.to_not be_able_to(:assign_user_to_task, task) }

        it { is_expected.to_not be_able_to(:new, Task) }
        it { is_expected.to_not be_able_to(:create, Task) }

        it { is_expected.to_not be_able_to(:new, Comment) }
        it { is_expected.to_not be_able_to(:create, Comment) }

        context 'on the task he has been assigned to' do
          let(:task) { create(:task, project: project, user: user) }

          it { is_expected.to_not be_able_to(:edit, task, user_id: user.id) }
          it { is_expected.to_not be_able_to(:update, task, user_id: user.id) }
        end

        context "on someone else's task" do
          let(:task) { create(:task, project: project) }

          it { is_expected.to_not be_able_to(:edit, task, user_id: user.id) }
          it { is_expected.to_not be_able_to(:update, task, user_id: user.id) }
        end

        context 'for his own comments' do
          let(:comment) { create(:comment, task: task, user: user) }

          it { is_expected.to_not be_able_to(:edit, comment, user_id: user.id) }
          it {
            is_expected.to_not be_able_to(:update, comment, user_id: user.id)
          }
          it {
            is_expected.to_not be_able_to(:destroy, comment, user_id: user.id)
          }
        end

        context "for the other's comments" do
          it {
            is_expected.to_not be_able_to(:edit, comment, user_id: user.id)
          }
          it {
            is_expected.to_not be_able_to(:update, comment, user_id: user.id)
          }
          it {
            is_expected.to_not be_able_to(:destroy, comment, user_id: user.id)
          }
        end
      end
    end
  end
end
