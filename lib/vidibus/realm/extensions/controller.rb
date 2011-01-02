module Vidibus
  module Realm
    module Extensions
      module Controller
        extend ActiveSupport::Concern

        included do
          helper_method :realm
        end

        # Ensures that a realm is present.
        def ensure_realm!
          realm or render(:text => "Realm required!", :status => :unauthorized)
        end

        # Returns the current realm.
        def realm
          env[:realm]
        end
      end
    end
  end
end
