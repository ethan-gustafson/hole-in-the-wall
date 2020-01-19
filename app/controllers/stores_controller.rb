class StoresController < ApplicationController

    get '/stores' do
        erb :'/stores/show_stores'
    end

    get '/my-stores' do

    end


end