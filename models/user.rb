class User
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :password, BCryptHash

  has n, :posts, child_key: [:user_id]
end