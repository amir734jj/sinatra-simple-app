require "sinatra"
require "data_mapper"

set :port, 80
set :bind, '0.0.0.0'
set :public_folder, File.dirname(__FILE__) + "/views"
enable :sessions

DataMapper.setup(:default, "sqlite3:db.sqlite")

get "/list" do
  User.all()
end

get "/" do
  if session["user"]
    erb :index, :layout => :layout, :locals => {:user => session["user"]}
  else
    erb :index, :layout => :layout
  end
end

get "/login" do
  if session["user"]
    redirect("/")
  else
    erb :login, :layout => :layout
  end
end

get "/register" do
  if session["user"]
    redirect("/login")
  else
    erb :register, :layout => :layout
  end
end

get "/logout" do
  session.clear
  redirect("/")
end

post "/login" do
  if params["email"] and params["password"]
    session["user"] = User.first(
        :email => params["email"],
        :password => params["password"]
    )

    redirect("/")
  else
    "Invalid query!"
  end
end

post "/register" do
  puts params["name"]

  if params["name"] and params["username"] and params["password"] and params["email"]
    User.create(
        :name => params["name"],
        :username => params["username"],
        :password => params["password"],
        :email => params["email"]
    )

    redirect("/login")
  else
    "Invalid query!"
  end
end

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

DataMapper.finalize
DataMapper.auto_upgrade!

