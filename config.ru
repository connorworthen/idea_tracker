require './config/environment'

use Rack::MethodOverride
use UserController
use IdeaController
run ApplicationController