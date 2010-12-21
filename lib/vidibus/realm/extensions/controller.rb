module Vidibus
  module Realm
    module Extensions
      module Controller
        extend ActiveSupport::Concern

        included do
          helper_method :realm
        end

        # Ensures that subdomain is present
        def ensure_subdomain!
          subdomain or render(:text => "Subdomain required!", :status => :unauthorized)
        end

        # Returns current subdomain which is, for now, the realm uuid itself.
        def subdomain
          @subdomain ||= begin
            request.host_with_port.match(/(.+)\.#{::Service.this.domain}/)
            if $1
              s = OpenStruct.new
              s.realm = $1
              s
            end
          end
        end

        # Returns realm from subdomain or constant.
        def realm
          subdomain ? subdomain.realm : VIDIBUS_REALM
        end
      end
    end
  end
end
