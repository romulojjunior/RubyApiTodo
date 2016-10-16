module API
  module Helpers
    module Auth
      def validate_api_key
        @current_user ||= auth_service.current_user(api_key)
      end

      def current_user
        @current_user ||= validate_api_key
      end

      private

      def auth_service
        @auth_service ||= AuthService.new
      end

      def api_key
        @api_key ||= headers["Authorization"]
      end
    end
  end
end
