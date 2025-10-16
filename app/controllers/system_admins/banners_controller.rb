module SystemAdmins
  class BannersController < SystemAdmins::BaseController
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
        redirect_to system_admins_banner_path(@banner), notice: "Banner criado."
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
        redirect_to system_admins_banner_path(@banner), notice: "Banner atualizado."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @banner.destroy
      redirect_to system_admins_banners_path, notice: "Banner removido."
    end

    private

    def set_banner
      @banner = SystemAdmins::Banner.find(params[:id])
    end

    def banner_params
      params.require(:system_admins_banner)
            .permit(:link, :start_date, :end_date, :interval, :image, :plan_id, :client_ids_csv)
    end

    def handle_image_upload
      upload = params[:system_admins_banner][:image]
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