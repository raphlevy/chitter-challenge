require './app/data_mapper_setup'
require 'sinatra/base'
require './spec/helpers/session_helper'

class App < Sinatra::Base

enable :sessions
set :session_secret, 'super secret'

  get '/' do
    p current_user
    erb :index
  end

  get '/users/new' do
    erb :'users/new'
  end

  post'/users' do
    @user = User.create(email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])
    if @user.save
      session[:user_id] = @user.id
      redirect to('/')
    end
  end

  helpers do
    def current_user
     current_user ||= User.get(session[:user_id])
    end
  end

  set :views, proc { File.join(root, '..', 'views') }

  # start the server if ruby file executed directly
  run! if app_file == $0
end
