class Api::V1::UsersController < Api::V1::ApiController
  def profile
    render json: current_user
  end
end