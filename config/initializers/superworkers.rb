Superworker.define(:NewPostWorker, :new_post) do
  ReceiveNewPostWorker :new_post
  UpdateFollowersWorker :new_post
end