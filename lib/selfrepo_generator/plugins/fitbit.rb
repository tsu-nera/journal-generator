require 'fitbit_api'

module SelfrepoGenerator
  module Plugins
    class Fitbit
      def initialize
        @client = FitbitAPI::Client.new(client_id: Settings.fitbit.client_id,
                                        client_secret: Settings.fitbit.client_secret,
                                        access_token: Settings.fitbit.access_token,
                                        refresh_token: Settings.fitbit.refresh_token,
                                        expires_at: 1234567890,
                                        user_id: Settings.fitbit.user_id)
      end

      def get
        @client.sleep_logs Date.today
      end
    end
  end
end

