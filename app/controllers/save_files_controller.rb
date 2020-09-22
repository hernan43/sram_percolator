class SaveFilesController < ApplicationController
  before_action :set_save_file, only: [:show, :edit, :update, :destroy]

  # GET /save_files
  # GET /save_files.json
  def index
    @save_files = SaveFile.all
  end

  # GET /save_files/1
  # GET /save_files/1.json
  def show
  end

  # GET /save_files/new
  def new
    @save_file = SaveFile.new
  end

  # GET /save_files/1/edit
  def edit
  end

  # POST /save_files
  # POST /save_files.json
  def create
    @save_file = SaveFile.new(save_file_params)

    respond_to do |format|
      if @save_file.save
        format.html { redirect_to @save_file, notice: 'Save file was successfully created.' }
        format.json { render :show, status: :created, location: @save_file }
      else
        format.html { render :new }
        format.json { render json: @save_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /save_files/1
  # PATCH/PUT /save_files/1.json
  def update
    respond_to do |format|
      if @save_file.update(save_file_params)
        format.html { redirect_to @save_file, notice: 'Save file was successfully updated.' }
        format.json { render :show, status: :ok, location: @save_file }
      else
        format.html { render :edit }
        format.json { render json: @save_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /save_files/1
  # DELETE /save_files/1.json
  def destroy
    @save_file.destroy
    respond_to do |format|
      format.html { redirect_to save_files_url, notice: 'Save file was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_save_file
      @save_file = SaveFile.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def save_file_params
      params.require(:save_file).permit(:name, :game_id, :notes)
    end
end
