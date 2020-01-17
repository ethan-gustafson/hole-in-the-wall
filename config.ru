require './config/environment'

use Rack::MethodOverride
use UsersController
use ReviewsController
run ApplicationController