class Ability
  include CanCan::Ability

  def initialize(user, current_project)
    
    user ||= User.new
    can :read, :all
    cannot :filter_tasks, Project
    
    if user.manager_role?
      can :manage, Project, user_id: user.id
      can :manage, Task, project: { user_id: user.id }
      can :manage, Comment, task: { project: { user_id: user.id } }
      cannot :filter_tasks, Project
    end
    
    if user.developer_role?
      can :filter_tasks, Project
      cannot :assign_user_to_task, Task
      if user.projects.include? current_project
        can [:new, :create], Task
        can [:edit, :update], Task, user_id: user.id
        can [:new, :create], Comment
        can [:edit, :update, :destroy], Comment, user_id: user.id
      end
    end
    
  end
end
