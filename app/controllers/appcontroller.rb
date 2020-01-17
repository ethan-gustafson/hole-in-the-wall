class AppController < Sinatra::Base

    configure do
        set :public_folder, 'public' # tells the appcontroller where to find the public folder.
        set :views, 'app/views' # tells the appcontroller where to find the views.
        enable :sessions # sessions is a hash
        set :session_secret, "no_hack" # an encryption key that that creates a session_id.
      end

    get '/hole-in-the-wall' do  
        erb :index # Offers a sign up or log in page.
    end

    get '/home' do 
        if logged_in?
        erb :home # Shows all stores, shows account and log out buttons.
        else
            redirect to '/hole-in-the-wall'
        end
    end

    get '/login' do
        erb :login # has a login form.
    end

    post '/login' do # posts to login and redirects to the home if successful.
    @user = User.find_by(:username => params[:username])
        
        if !!@user && @user.authenticate(params[:password]) # If it is a valid user and the password is authenticated.
            session[:user_id] = @user.id # we set the sessions user_id to equal the @user.id.
            redirect to '/home'
        else
            redirect '/error'
        end
    end

    get '/signup' do # has the sign up form.
        erb :signup
    end

    post '/signup' do # signs up a user and redirects them to the home page or error page.
        @user_signup = User.new(:name => params[:name], :username => params[:username], :email => params[:email], :password => params[:password])

            if @user_signup.save # If it is a valid user and the password is authenticated.
            session[:user_id] = @user_signup.id
            redirect '/home'
            elsif @user_signup.invalid? # if the params are empty, bad data won't be uploaded.
                redirect '/error'
        else
            redirect '/error'
        end
    end

    get '/account' do # Shows the users reviews, favorite stores and the logout button.
        @session_user = User.find_by(id: session[:user_id]) # gives you the correct user
        if logged_in?
        erb :account
        else
            redirect to '/hole-in-the-wall'
        end
    end

    get "/my-reviews" do
        if logged_in?
        @reviews = current_user.reviews # shows all of this specific user's reviews
        erb :'/reviews/my_reviews' # Gives links to each review - Gives link to the Home Page
        else
            redirect to '/hole-in-the-wall'
        end
    end

    get "/my-reviews/form" do # shows the review form
        if logged_in?
        erb :'/reviews/review_form'
        else
            redirect to '/hole-in-the-wall'
        end
    end

    post "/my-reviews" do
        @review = Review.new(:title => params[:review][:title], :content => params[:review][:content], :user_id => current_user.id) # When a new review is created
        redirect to "/my-reviews/#{@review.id}" # it is redirected to that specific review from @review
        # add logic for validation
    end

    get "/my-reviews/:id" do
        @user_review = Review.find_by_id(params[:id]) # finds the right review from post "/my-reviews" @review

        if logged_in? && current_user.id == @user_review.user_id # if the user is logged in and their user_id is equal to the @user_review params id
        erb :'/reviews/individual_review' # Shows the correct review.
        elsif !logged_in?
            redirect to '/hole-in-the-wall'
        else
            erb :'/reviews/no_access'
        end
    end

    get "/my-reviews/:id/edit" do
        @user_review = Review.find_by_id(params[:id]) # keeps the same id from the right review

        if logged_in? && current_user.id == @user_review.user_id # if the user is logged in and their user_id is equal to the @user_review params id
        erb :'/reviews/edit' # Allows the user to edit that review.
        elsif !logged_in?
            redirect to '/hole-in-the-wall'
        else
            erb :'/reviews/no_access' # they get the error message if it is not their review
        end
    end

    patch "/my-reviews/:id" do # patch request to the specific id
        @editing = Review.find_by_id(params[:id]) # finds the right id to patch
        if logged_in? && current_user.id == @editing.user_id
            if valid_params?
                @editing.update(params[:review])
                redirect to "/my-reviews/#{@editing.id}" # redirects to the specific id page
            else
                redirect to '/my-reviews/form'
            end
        else
            erb :'/reviews/no_access'
        end
    end

    delete "/my-reviews/:id" do
        @deletion = Review.find_by_id(params[:id]) # will find the review by the params id

        if logged_in? && current_user.id == @deletion.user_id # if the current user is equal to the review user id
        @deletion.delete # then we will delete the post. 
        redirect '/my-reviews' # Redirected to their reviews.
        else
            erb :'/reviews/no_access' # if they do not, then they shall get the error page.
        end
    end

    get '/error' do # shows an error message that will tell the user to go back and log in or sign up.
        erb :error
    end

    get "/logout" do# logs out the user.
		session.clear
		redirect "/hole-in-the-wall"
	end

    helpers do
        def logged_in? # verifies that the session is true.
			!!session[:user_id]
		end

		def current_user # identifies the current user.
			User.find(session[:user_id])
        end
        
        def valid_params?
            params[:review].none? do |key,value|
                value == ""
            end
        end

	end
end