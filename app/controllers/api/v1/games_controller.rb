class Api::V1::GamesController < Api::V1::ApiController
  before_action :set_game, except: [:create, :index, :lookup]

  def create
    @game = Game.find_or_create_by(name: game_params[:name], user_id: current_user.id)

    if @game.update(game_params)
      render json: @game
    else
      render json: @game.errors, status: :unprocessable_entity
    end
  end

  def index
    if not params[:mtime].empty?
      render json: current_user.games.joins(:save_files).where('save_files.mtime >= ?', DateTime.parse(params[:mtime])).order(:name)
    else
      render json: current_user.games.order(:name)
    end
  end

  def lookup
    @game = current_user.games.find_by_name(params[:name])
    if not @game.nil?
      render json: @game
    else
      head :ok
    end
  end

  def show
    render json: @game
  end

  private
  
  def set_game
    @game = current_user.games.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:name, :platform_list)
  end
end