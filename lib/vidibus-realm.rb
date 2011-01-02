require "active_support"

$:.unshift(File.join(File.dirname(__FILE__), "vidibus"))
require "realm"
require "realm/rack"

if defined?(::Rails)
  module Vidibus
    module Realm
      class Engine < ::Rails::Engine
        config.app_middleware.use("Vidibus::Realm::Rack")
      end
    end
  end
end
