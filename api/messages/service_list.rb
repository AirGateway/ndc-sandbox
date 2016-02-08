module API

  module Messages

    class ServiceListRQ < API::Messages::Base
      require "redis"

      @response_name = "service_list"
      class << self
        attr_reader :response_name
      end

      attr_reader :services

      def initialize(doc)
        super (doc)
        response_id = @doc.xpath('/ServiceListRQ/ShoppingResponseIDs/ResponseID').text
        od = JSON.parse(get_request(response_id))
        routes = Route.fetch_by_ond_and_dates(od["dep"], od["arr"], od["date_dep"])
        @services = routes.services
        @response = build_response
      end

			def get_request(response_id)
        redis = Redis.new(:host => "127.0.0.1", :port => 6380, :db => 15)
        redis.get(response_id)
			end
    end

  end

end
