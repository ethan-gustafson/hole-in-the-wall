require 'pry'
require 'sinatra/base'
require 'sinatra/flash'
class ApplicationController < Sinatra::Base
    register Sinatra::Flash

    configure do
        set :public_folder, 'public'
        set :views, 'app/views'
        enable :sessions
        set :session_secret, File.read("config/keys/session_secret.txt")
      end

      helpers do

        # Google will send you emails about your exposed API key for google maps on github.
        # Putting the api key in the gitignore will hide the key
        # Reading from the file directly will hide the api_key

        def google_api
            @google_api_key ||= File.read("config/keys/API_KEY.txt")
        end

        def logged_in? 
			!!current_user # will return true if a record is present, will return false if the current_user is nil.
        end
        
        def redirect_inside?
            redirect '/' if logged_in? # if the current_user tries to access the login page, they will be redirected 
        end

        def redirect_outside?
            flash[:invalid]  = "You have to sign up to come inside. ;)"
            redirect '/login' if !logged_in? # if a non-user tries to access pages where they need to be logged in, they will be redirected 
        end

		def current_user # If there is a session, then a user is logged in. Don't set @current_user again if already set.
			@current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
        end

        # singular_class_name takes the controller name and splits it at the "C" of Controller.
        # Controllers are defined as plural, so slicing from the start of the string to the letter before the end will make
        # the class name singular.
        # The first array item is the name of the class model name of the resource you are trying to access.

        def singular_class_name
            class_name = self.class.to_s.split("C")[0].downcase 
            @singular  = class_name.slice(0..-2)

            if @singular == "session"
                @singular = "user"
            end
            @singular
        end
        
        # Sinatra uses Indifferent Hashes with params. This means it regards string and key symbols the same.
        # https://www.rubydoc.info/gems/sinatra/Sinatra/IndifferentHash

        def require_param(key) # This method requires an argument of the main key of each class.
            if singular_class_name == key.to_s # if the controller class name is equal to the key argument passed in
                if params.has_key?(singular_class_name) # and if the params has that key of the class
                    hash = Hash.new # create a new hash
                    hash.store(key, {}) # store the "main" key into the hash
                    hash # return the hash
                end
            else
                return false # otherwise return false and validations will fail.
            end
        end

        # A parameter with the splat(*) operator allows a method to work with an undefined number of arguments
        # A parameter with the splat operator converts the arguments to an array within a method
        # The arguments are passed in the same order in which they are specified when a method is called
        # https://docs.ruby-lang.org/en/2.0.0/syntax/calling_methods_rdoc.html
        # https://medium.com/@sologoubalex/parameter-with-splat-operator-in-ruby-part-1-2-a1c2176215a5

        def permit_params(hash, *attributes) 
             # For each attribute, check if the class has those attributes.
            attributes.each do |key| 
                if Class.const_get(singular_class_name.capitalize).attribute_names.include?(key.to_s) 
            # If they do have the attribute, store them and the params value for that attribute into the hash given from require_param
                    hash[singular_class_name.to_sym].store(key, params[singular_class_name][key])
                    hash
                end
            end
            hash
        end

    end
end