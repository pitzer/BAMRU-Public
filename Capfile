SERVER       = "ss5"
APPDIR       = "BAMRU-Public"

set :application, "BAMRU TEST APP"

load 'deploy' if respond_to?(:namespace)
Dir['vendor/plugins/*/recipes/*.rb'].each { |p| load p }
Dir['lib/shared/recipes/*.rb'].each { |p| load p }


