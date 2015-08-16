class Follower < ActiveRecord::Base
  has_many :followed_bys

  has_many :shoppers, :through => :followed_bys, :source => :followable, :source_type => 'Shopper'
  has_many :brands, :through => :followed_bys, :source => :followable, :source_type => 'Brand'
end