module ApplicationHelper

    # The states method is reading from the ./app/assets/files/states.txt file which is a list of all states & their abbreviations.
    # It will read the file and then split it where there is a line break("\n"). Once it has been turned into an array of values,
    # it will iterate through each array item and slice the state name as a key, and slice off the ending abbreviation as the value.
    # The resulting @states instance variable will now hold a hash of key/value pairs of {state: abbreviation}. This method is
    # only set to run once, when the application is initiated, so that it won't set the @states instance variable again.

    def get_states
        filepath     = File.join(".", "app", "assets", "files", "states.txt")
        file         = File.read(filepath)
        states_array = file.split("\n")

        states = {}

        states_array.each do |state|
            key                = state.slice(0, state.index("-") - 1)
            value              = state.slice((state.length - 2), state.length)
            states[key.to_sym] = value
            @states = states
        end
        @states
    end

    def states
        @states ||= get_states
    end

    def current_user # If there is a session, then a user is logged in. Don't set @current_user again if already set.
        @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
    end

    def logged_in? 
        !!current_user # will return true if a record is present, will return false if the current_user is nil.
    end
    
    def redirect_inside?
        redirect '/' if logged_in? # if the current_user tries to access the login page, they will be redirected 
    end

    def redirect_outside?
        redirect '/login' if !logged_in? # if a non-user tries to access pages where they need to be logged in, they will be redirected 
    end

end