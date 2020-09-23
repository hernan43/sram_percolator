class Api::V1::SaveFilesController < Api::V1::ApiController
  before_action :set_game
  before_action :set_save_file, only: [:show, :edit, :update, :destroy]

  def index
    render json: @game.save_files
  end

  def show
    render json: @save_file
  end

  def create
    @save_file = SaveFile.new(save_file_params)
    @save_file.game = @game

    if @save_file.save
      render json: @save_file
    else
      render json: @save_file.errors, status: :unprocessable_entity
    end
  end

  def update
    if @save_file.update(save_file_params)
      render json: @save_file
    else
      render json: @save_file.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @save_file.destroy
    head :no_content
  end

private
  def set_game
    @game = current_user.games.find(params[:game_id])
  end

  def set_save_file
    @save_file = SaveFile.find(params[:id])
  end

  def save_file_params
    params.require(:save_file).permit(:name, :notes, :sram)
  end

end