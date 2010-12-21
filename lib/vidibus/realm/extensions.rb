require "realm/extensions/controller"

ActiveSupport.on_load(:action_controller) do
  include Vidibus::Realm::Extensions::Controller
end
