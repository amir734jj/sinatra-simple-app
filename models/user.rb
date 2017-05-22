class User
  include DataMapper::Resource
  property :id, Serial
  property :username, String
  property :password, String
  property :name, String
  property :email, String

  def to_str
    @name + "\t" + @username + "\t" + "\t" + @email
  end
end