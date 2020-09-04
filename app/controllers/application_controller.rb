require 'pry'
require 'ostruct'
require 'sinatra/base'
class ApplicationController < Sinatra::Base

    configure do
        set :public_folder, 'public'
        set :views, 'app/views'
        enable :sessions
        set :session_secret, File.read("config/keys/session_secret.txt")
      end

      helpers do

        def google_api
            @google_api_key ||= File.read("config/keys/API_KEY.txt")
        end

        def logged_in? # verifies that the session is true.
			!!current_user
        end
        
        def redirect_if_not_logged_in?
            if !logged_in?
                redirect '/login'
            end
        end

        def redirect_if_logged_in_user_accesses_a_not_logged_in_page?
            if logged_in? 
                redirect '/login'
            end
        end

		def current_user # identifies the current user.
			@current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
        end

        def class_name
            @class_name = self.class.to_s.split("C")[0].downcase
        end

        def singular_class_name
            class_name
            @singular = @class_name.slice(0..-2)

            if @singular == "session"
                @singular = "user"
            end
            @singular
        end
        
        # Sinatra uses Indifferent Hashes with params. This means it regards string and key symbols the same.
        # https://www.rubydoc.info/gems/sinatra/Sinatra/IndifferentHash

        def require_param(key)
            if singular_class_name == key.to_s
                if params.has_key?(singular_class_name)
                    hash = Hash.new
                    hash.store(key, {})
                    hash
                end
            else
                return false
            end
        end

        def permit_params(hash, *attributes) # needs to be
                attributes.each do |key| 
                    if Class.const_get(singular_class_name.capitalize).attribute_names.include?(key.to_s) 
                        hash[singular_class_name.to_sym].store(key, params[singular_class_name][key])
                        hash
                    end
                end
            hash
        end

    end

end