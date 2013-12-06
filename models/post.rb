class Post
  include DataMapper::Resource

  property :id,       Serial
  property :date,     Date
  property :titel,    String
  property :content,  String

  belongs_to :user, 'User', key: true
end