module ApplicationHelper
  def current_user 
    @current_user = User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def is_current_user
    current_user.id.equal?(params[:id].to_i)
  end

  def logged_in? 
    !!current_user
  end
  
  def redirect_to(path)
    redirect path
  end

  def redirect_current_user_back_to_root?
    redirect_to root_path if logged_in? 
  end

  def redirect_logged_out_user_to_login?
    redirect_to login_path if !logged_in?
  end 

  def add_attributes(params, class_name, *permitted_params)
    required_param = class_name.to_s.downcase.to_sym
    attributes = {required_param => {}}
    permitted_params.each do |p|
      attributes[required_param][p] = params[required_param][p]
    end
    attributes[required_param]
  end

  def new_strong_params(params, class_name, *permitted_params)
    parameters = add_attributes(params, class_name, *permitted_params)
    class_name.new(parameters)
  end

  def update_strong_params(params, class_name, object, *permitted_params)
    parameters = add_attributes(params, class_name, *permitted_params)
    object.update(parameters)
  end

  def get_states
    filepath     = File.join(".", "app", "assets", "files", "states.txt")
    file         = File.read(filepath)
    states_array = file.split("\n")
    states       = {}

    states_array.each do |state|
      key                = state.slice(0, state.index("-") - 1) # Florida
      value              = state.slice((state.length - 2), state.length) # FL
      states[key.to_sym] = value
    end
    states
  end

  def states
    @states ||= get_states
  end
end