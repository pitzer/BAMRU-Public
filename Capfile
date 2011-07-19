# SERVER       = "gg2"
# SERVER       = "r210x.com"
SERVER       = "backup.x440.com"
APPDIR       = "BAMRU-Public"

set :application, "BAMRU Public"

load 'deploy' if respond_to?(:namespace)
Dir['vendor/plugins/*/recipes/*.rb'].each { |p| load p }
Dir['lib/shared/recipes/*.rb'].each { |p| load p }


