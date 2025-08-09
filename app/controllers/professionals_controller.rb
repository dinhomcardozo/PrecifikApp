module Roles
  class ProfessionalsController < ApplicationController
    def index
      pros = Professional.where(role_id: params[:role_id])
      render json: pros.select(:id, :full_name)
    end
  end
end