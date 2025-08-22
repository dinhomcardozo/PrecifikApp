# app/controllers/system_admins/banners_controller.rb
module SystemAdmins
  class BannersController < ApplicationController
    before_action :set_banner, only: %i[show edit update destroy]

    def index
      @banners = SystemAdmins::Banner.all
    end

    def show
    end

    def new
      @banner = SystemAdmins::Banner.new
    end

    def create
      @banner = SystemAdmins::Banner.new(banner_params)
      handle_image_upload
      if @banner.save
        redirect_to banner_path(@banner), notice: "Banner criado."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      @banner.assign_attributes(banner_params)
      handle_image_upload
      if @banner.save
        redirect_to banner_path(@banner), notice: "Banner atualizado."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @banner.destroy
      redirect_to banners_path, notice: "Banner removido."
    end

    private

    def set_banner
      @banner = SystemAdmins::Banner.find(params[:id])
    end

    def banner_params
      params.require(:banner)
            .permit(:link, :start_date, :end_date, :interval, :image)
    end

    def handle_image_upload
      upload = params[:banner][:image]
      return unless upload.respond_to?(:original_filename)

      filename = "#{SecureRandom.uuid}_#{upload.original_filename}"
      folder   = Rails.root.join("public", "uploads", "banners")
      FileUtils.mkdir_p(folder)
      filepath = folder.join(filename)

      File.open(filepath, "wb") { |f| f.write(upload.read) }
      @banner.image = "/uploads/banners/#{filename}"
    end
  end
end