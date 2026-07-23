class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def render_not_found(error)
    render_error(error.message, status: :not_found)
  end

  def render_error(message, status:)
    render json: { error: message }, status: status
  end
end
