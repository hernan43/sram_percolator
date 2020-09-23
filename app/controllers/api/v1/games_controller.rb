class Api::V1::GamesController < Api::V1::ApiController
  def index
    render json: current_user.games.order(:name)
  end
end