class FollowedBy < ActiveRecord::Base
  belongs_to :follower
  belongs_to :followable, :polymorphic => true
end