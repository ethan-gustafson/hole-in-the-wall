module ApplicationHelper
  def redirect_to(path)
    redirect path
  end

  def attr_to_object(required, *permitted)
    required_params = {}
    permitted.each do |param|
      required_params[param] = params[required][param]
    end
    required_params
  end
end