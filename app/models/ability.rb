class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # Guest user

    if user.role == 'admin'
      can :manage, :all
    else
      can :read, :all
      can :delete, [Post, Comment], author_id: user.id
      can :create, [Post, Comment] # Allow creating new posts and comments
      can :update, [Post, Comment], author_id: user.id # Allow updating their own posts and comments
    end
  end
end
