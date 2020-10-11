class ApplicationController < ActionController::Base
    include Pagy::Backend

    protected

    def require_signed_in_as_admin!
        authenticate_user!
        redirect_to root_path unless current_user.is_admin?
    end
end
