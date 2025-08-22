module SystemAdmins
  class UserClientsController < ApplicationController
    before_action :set_user_client, only: %i[ show edit update destroy ]

    def index
      @user_clients = SystemAdmins::UserClient.all
    end

    def show
    end

    def new
      @user_client = SystemAdmins::UserClient.new
    end

    def edit
    end

    def create
      @user_client = SystemAdmins::UserClient.new(user_client_params)

      respond_to do |format|
        if @user_client.save
          format.html { redirect_to @user_client, notice: "User client was successfully created." }
          format.json { render :show, status: :created, location: @user_client }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @user_client.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @user_client.update(user_client_params)
          format.html { redirect_to @user_client, notice: "User client was successfully updated." }
          format.json { render :show, status: :ok, location: @user_client }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @user_client.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @user_client.destroy!

      respond_to do |format|
        format.html { redirect_to user_clients_path, status: :see_other, notice: "User client was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    private
    def set_user_client
      @user_client = SystemAdmins::UserClient.find(params.expect(:id))
    end

    def user_client_params
      params.expect(user_client: [ :user_id, :client_id ])
    end
  end
end
