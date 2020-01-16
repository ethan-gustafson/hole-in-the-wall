require './config/environment'

use Rack::MethodOverride
use Rack::Session::Pool, :expire_after => 2592000 # seconds
use Rack::Protection::RemoteToken
use Rack::Protection::SessionHijacking
run AppController