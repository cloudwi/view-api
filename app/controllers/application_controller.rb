class ApplicationController < ActionController::API
  include ApiResponse

  # 전역 예외 처리
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
  rescue_from StandardError, with: :handle_internal_error if Rails.env.production?

  private

  def authenticate_user!
    render_unauthorized unless current_user
  end

  def current_user
    @current_user ||= begin
      token = request.headers["Authorization"]&.split(" ")&.last
      return nil unless token

      decoded = JwtService.decode(token)
      return nil unless decoded

      User.find_by(id: decoded[:user_id])
    end
  end

  def handle_not_found(exception)
    render_error("NOT_FOUND", exception.message, status: :not_found)
  end

  def handle_parameter_missing(exception)
    render_error("PARAMETER_MISSING", exception.message, status: :bad_request)
  end

  def handle_internal_error(exception)
    Rails.logger.error("Internal Server Error: #{exception.class} - #{exception.message}")
    Rails.logger.error(exception.backtrace.join("\n"))
    render_error("INTERNAL_ERROR", "서버 오류가 발생했습니다", status: :internal_server_error)
  end
end
