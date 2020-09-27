class Api::V1::GamesController < Api::V1::ApiController
  before_action :set_game, except: [:index]

  def index
    render json: current_user.games.order(:name)
  end

  def show
    render json: @game
  end

  def lookup
    @game = current_user.games.find_by_name(params[:name])
    render json: @game
  end

  private
  
  def set_game
    @game = current_user.games.find(params[:id])
  end
end