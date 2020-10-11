class BaseController < ApplicationController
    before_action :authenticate_user!
    def index
        #@tags = current_user.games.tag_counts_on(:platforms)
        @tags = current_user.platforms
    end
end