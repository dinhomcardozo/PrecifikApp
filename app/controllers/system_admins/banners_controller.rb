class SystemAdmins::BannersController < ApplicationController
  before_action :set_system_admins_banner, only: %i[ show edit update destroy ]

  # GET /system_admins/banners or /system_admins/banners.json
  def index
    @system_admins_banners = SystemAdmins::Banner.all
  end

  # GET /system_admins/banners/1 or /system_admins/banners/1.json
  def show
  end

  # GET /system_admins/banners/new
  def new
    @system_admins_banner = SystemAdmins::Banner.new
  end

  # GET /system_admins/banners/1/edit
  def edit
  end

  # POST /system_admins/banners or /system_admins/banners.json
  def create
    @system_admins_banner = SystemAdmins::Banner.new(system_admins_banner_params)

    respond_to do |format|
      if @system_admins_banner.save
        format.html { redirect_to @system_admins_banner, notice: "Banner was successfully created." }
        format.json { render :show, status: :created, location: @system_admins_banner }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @system_admins_banner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /system_admins/banners/1 or /system_admins/banners/1.json
  def update
    respond_to do |format|
      if @system_admins_banner.update(system_admins_banner_params)
        format.html { redirect_to @system_admins_banner, notice: "Banner was successfully updated." }
        format.json { render :show, status: :ok, location: @system_admins_banner }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @system_admins_banner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /system_admins/banners/1 or /system_admins/banners/1.json
  def destroy
    @system_admins_banner.destroy!

    respond_to do |format|
      format.html { redirect_to system_admins_banners_path, status: :see_other, notice: "Banner was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_admins_banner
      @system_admins_banner = SystemAdmins::Banner.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def system_admins_banner_params
      params.expect(system_admins_banner: [ :image, :link, :start_date, :end_date ])
    end
end
