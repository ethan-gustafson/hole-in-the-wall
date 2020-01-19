require './config/environment'

use Rack::MethodOverride
use UsersController
use ReviewsController
use StoresController
run ApplicationController