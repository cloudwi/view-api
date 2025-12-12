class ApplicationController < ActionController::API
  private

  def authenticate_user!
    return render_unauthorized unless current_user
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

  def render_unauthorized
    render json: { error: "Unauthorized" }, status: :unauthorized
  end
end
