require './config/environment'

use Rack::MethodOverride
use UserController
use IdeaController
use ListController
run ApplicationController