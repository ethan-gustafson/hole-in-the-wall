require_relative './config/environment'

use Rack::MethodOverride
use SessionsController
use UsersController
use ReviewsController
use StoresController
use FavoritesController
run ApplicationController
