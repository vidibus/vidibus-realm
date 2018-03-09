module Vidibus
  module Realm
    module Extensions
      module Controller
        extend ActiveSupport::Concern

        included do
          helper_method(:realm) if respond_to?(:helper_method)
        end

        # Ensures that a realm is present.
        def ensure_realm!
          realm or render(:text => "Realm required!", :status => :unauthorized)
        end

        # Returns the current realm.
        def realm
          env[:realm]
        end

        # Sets the current realm.
        # Usually the realm will be detected and set by the Rack app.
        def set_realm(value)
          env[:realm] = value
        end
      end
    end
  end
end
