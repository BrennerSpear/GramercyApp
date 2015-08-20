Superworker.define(:NewPostWorker, :new_post) do
	ReceiveNewPostWorker :new_post
	UpdatePostersFollowersWorker :new_post
end
