# app/controllers/system_admins/banners_controller.rb
module SystemAdmins
  class BannersController < ApplicationController
    before_action :set_banner, only: %i[show edit update destroy]

    def index
      @system_admins_banners = SystemAdmins::Banner.all
    end

    def show
    end

    def new
      @system_admins_banner = SystemAdmins::Banner.new
    end

    def create
      @system_admins_banner = SystemAdmins::Banner.new(banner_params)
      handle_image_upload
      if @system_admins_banner.save
        redirect_to system_admins_banner_path(@system_admins_banner), notice: "Banner criado."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      @system_admins_banner.assign_attributes(banner_params)
      handle_image_upload
      if @system_admins_banner.save
        redirect_to system_admins_banner_path(@system_admins_banner), notice: "Banner atualizado."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @system_admins_banner.destroy
      redirect_to system_admins_banners_path, notice: "Banner removido."
    end

    private

    def set_banner
      @system_admins_banner = SystemAdmins::Banner.find(params[:id])
    end

    def banner_params
      params.require(:system_admins_banner)
            .permit(:link, :start_date, :end_date, :interval, :image)
    end

    def handle_image_upload
      upload = params[:system_admins_banner][:image]
      return unless upload.respond_to?(:original_filename)

      filename = "#{SecureRandom.uuid}_#{upload.original_filename}"
      folder   = Rails.root.join("public", "uploads", "banners")
      FileUtils.mkdir_p(folder)
      filepath = folder.join(filename)

      File.open(filepath, "wb") { |f| f.write(upload.read) }
      @system_admins_banner.image = "/uploads/banners/#{filename}"
    end
  end
end