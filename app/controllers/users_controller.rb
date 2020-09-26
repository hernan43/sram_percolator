class UsersController < ApplicationController
  before_action :authenticate_user!

  def edit
  end

  def profile
    @tags = current_user.games.tag_counts_on(:platforms)
  end

  def update
    respond_to do |format|
      if current_user.update(user_params)
        format.html { redirect_to user_profile_path }
      else
        format.html { render action: :edit }
      end
    end
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email)
    end
end
