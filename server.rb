require "sinatra"
require "data_mapper"
require_relative "models/user"

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
    if params["username"] and params["password"]
        user = User.first(
            :username => params["username"],
            :password => params["password"]
        )

        # if user exist then add attributes to session otherwise redirect to login with error message
        if user
            session["user"] = user
            redirect("/")
        else
            erb :login, :layout => :layout, :locals => {:user => session["user"], :message => "Invalid password! please try again."}
        end
    else
        "invalid query!"
    end
end

post "/register" do
    if params["name"] and params["username"] and params["password"] and params["email"]
        user = User.first(
            :username => params["username"]
        )

        # if username already exist then show error message and try again to register
        if user
            erb :register, :layout => :layout, :locals => {:user => session["user"], :message => "Username already exist in database. Please try another one."}
        else
            user = User.create(
                :name => params["name"],
                :username => params["username"],
                :password => params["password"],
                :email => params["email"]
            )

            redirect("/login")
        end
    else
        "Invalid query!"
    end
end

DataMapper.finalize
