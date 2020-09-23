class Api::V1::SaveFilesController < Api::V1::ApiController
  before_action :set_game

  def index
    render json: @game.save_files
  end

  protected

  def set_game
    @game = current_user.games.find(params[:game_id])
  end
end