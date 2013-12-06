class Dagbok < Sinatra::Base
  enable :sessions

  get '/' do
    slim :'index'
  end

  get '/register' do
    slim :'register'
  end

  post '/newuser' do
    User.create(name: params[:name], password: params[:password])
    redirect '/'
  end

  post '/login' do
    user = User.first(name: params['name'])
    if user && user.password == params['password']
      session[:user] = user.id
      redirect "/user/#{user.id}"
    else
      return 403, "Booooh!"
    end
  end

  get '/user/:id' do |id|
    @user = User.get(session[:user].to_i)
    @posts = Post.all(user_id: id.to_i)
    slim :'user/list_posts'
  end

  post '/logout' do
    session.destroy
    redirect '/'
  end

  get '/post' do
    @user = User.get(session[:user].to_i)
    slim :'user/new_post'
  end

  post '/post' do
    @user = User.get(session[:user].to_i)
    Post.create(date: Date.today, titel: params[:titel], content: params[:content], user_id: @user.id.to_i)
    redirect "/user/#{@user.id.to_i}"
  end

  get '/user/:user/:post_id' do |user_id,post_id|
    @user = User.get(session[:user].to_i)
    if @user.id == user_id.to_i
      @post = Post.first(id: post_id.to_i, user: @user)
      slim :'user/show_post'
    else
      return 403, "Boooooh!"
    end
  end

  post '/search' do
    @user = User.get(session[:user].to_i)
    @posts = Post.all(user: @user, :titel.like => "%#{params[:searchtitel]}%")
    slim :'user/search_post'
  end
end