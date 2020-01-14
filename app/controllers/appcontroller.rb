require "./config/environment"
class AppController < Sinatra::Base
    
    get '/hole-in-the-wall' do
        erb :home
    end

    get '/hole-in-the-wall/login' do

    end

    get '/hole-in-the-wall/signup' do

    end
end