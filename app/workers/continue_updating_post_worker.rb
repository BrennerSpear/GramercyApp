class ContinueUpdatingPostWorker
	include Sidekiq::Worker


	def perform(post_id, count)

		#update the likes
		post = Post.find(post_id)
		post.update_likes

		#depending on how long it's been since the post, decide how long the next wait time will be
		#the count should start at 107
		case count
		when 71..101
			wait_time = 1.minute
		when 65..70
			wait_time = 5.minutes
		when 1..65
			wait_time = 1.hour
		else
			count = 0
			puts "count was not between 1 and 107"
		end

		#come down 1 count, continue
		count -= 1

		#stop when it gets to 0
		if count >= 1
			ContinueUpdatingPostWorker.perform_in(wait_time, post_id, count)
		end


	end
end