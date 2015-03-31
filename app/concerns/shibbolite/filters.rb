# controller filters for access control
module Shibbolite
  module Filters
    extend ActiveSupport::Concern

    include Shibbolite::Helpers

    def require_login
      authenticate_request unless logged_in?
    end

    def require_registered
      authenticate_request unless registered_user?
    end

    def require_group(*groups)
      in_group = false
      groups.flatten.each { |group| in_group ||= user_in_group?(group) }
      authenticate_request unless in_group
    end

    def require_id(id)
      authenticate_request unless user_has_id?(id)
    end

    def require_group_or_id(*groups, id)
      unless user_has_id?(id)
        require_group(groups)
      end
    end

    def require_attribute(attr, value)
      authenticate_request unless user_has_matching_attribute?(attr, value)
    end

    def require_group_or_attribute(*groups, attr, value)
      unless user_has_matching_attribute?(attr, value)
        require_group(groups)
      end
    end

    def use_attributes_if_available
      if request.env[Shibbolite.pid.to_s] and not logged_in?
        authenticate_request
      end
    end

    # redirects the user to (re)authenticate with
    # the Idp or a 403 forbidden page
    def authenticate_request
      session[:requested_url] = request.fullpath

      url = logged_in? ? shibbolite.access_denied_url : shibbolite.login_url

      # redirect to the selected url
      respond_to do |format|
        format.html { redirect_to url }
        format.js   { render js: "window.location.assign('#{url}');"}
      end
    end
  end
end