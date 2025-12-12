module ApiResponse
  extend ActiveSupport::Concern

  private

  def render_success(data, meta: {}, status: :ok)
    render json: { data:, meta: }, status:
  end

  def render_error(code, message, status: :bad_request, details: nil)
    response = {
      error: {
        code:,
        message:
      }
    }
    response[:error][:details] = details if details.present?
    render json: response, status:
  end

  def render_validation_errors(record)
    render_error(
      "VALIDATION_ERROR",
      record.errors.full_messages.join(", "),
      status: :unprocessable_entity,
      details: record.errors.to_hash
    )
  end

  def render_not_found(resource = "Resource")
    render_error("NOT_FOUND", "#{resource} not found", status: :not_found)
  end

  def render_unauthorized
    render_error("UNAUTHORIZED", "인증이 필요합니다", status: :unauthorized)
  end

  def render_forbidden
    render_error("FORBIDDEN", "권한이 없습니다", status: :forbidden)
  end
end
