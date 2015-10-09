class UpdatePostLikesWorker
	include Sidekiq::Worker

	def perform(post_id)
		post = Post.find(post_id)
		post.update_likes
	end
end