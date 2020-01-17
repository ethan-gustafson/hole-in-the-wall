require './config/environment'

use Rack::MethodOverride
use Stores_Reviews_Controller
run AppController