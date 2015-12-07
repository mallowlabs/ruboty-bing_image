require "faraday"
require "faraday_middleware"

module Ruboty
  module BingImage
    class Client
      BING_IMAGE_API_URL = "https://api.datamarket.azure.com/Bing/Search/v1/Image"

      attr_reader :options

      def initialize(options)
        @options = options
      end

      def bing_api_key
        ENV['BING_API_KEY']
      end

      def get
        resource["MediaUrl"] if resource
      rescue => exception
        Ruboty.logger.error("Error: #{self}##{__method__} - #{exception}")
        nil
      end

      private

      def resource
        @resource ||= begin
          if data = response.body["d"]
            if results = data["results"]
              results.sample
            end
          end
        end
      end

      def response
        connection.get(url, params)
      end

      def url
        BING_IMAGE_API_URL
      end

      def params
        default_params.merge(given_params).reject {|key, value| value.nil? }
      end

      def given_params
        {
          "Query": "'#{options[:query]}'",
        }
      end

      def default_params
        {
          "Market": "'ja-JP'",
          "Adult": "'Strict'",
          "ImageFilters": "'Size:Medium'",
          "$format": "json",
        }
      end

      def connection
        Faraday.new do |connection|
          connection.adapter :net_http
          connection.response :json
          connection.basic_auth bing_api_key, bing_api_key
        end
      end
    end
  end
end

