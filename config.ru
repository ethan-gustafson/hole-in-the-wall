require './config/environment'

use Rack::MethodOverride
use UsersController
use ReviewsController
use StoresController
run ApplicationController

# The final step in creating a controller is mounting it in config.ru. 
# Mounting a controller means telling Rack that part of your web application is defined within the following class. 
# We do this in config.ru by using run ApplicationController where run is the mounting method and Application is 
# the controller class that inherits from Sinatra::Base and is defined in a previously required file.

