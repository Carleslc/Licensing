# Handles controller exceptions
module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordInvalid do |e|
      render json: { message: e.record.errors.full_messages[0] }
    end
    rescue_from ActionController::ParameterMissing, ActiveRecord::RecordNotUnique, I18n::InvalidLocale do |e|
      render json: { message: e.message }, status: :bad_request
    end
  end

end