require 'typhoeus'
require 'json'

  class ClientUser
    class << self
      attr_accessor :base_uri

      def find_by_name(name)
        response = Typhoeus::Request.get("#{base_uri}/api/v1/users/#{name}")
        if response.code == 200
          JSON.parse(response.body)
        elsif response.code == 404
          nil
        else
          raise response.body
        end
      end

      def create(attributes)
        response = Typhoeus::Request.post(
          "#{base_uri}/api/v1/users",
          body: attributes.to_json
        )
        if response.code == 200
          JSON.parse(response.body)
        else
          raise response.body
        end
      end

      def update(name, attributes)
        response = Typhoeus::Request.put(
          "#{base_uri}/api/v1/users/#{name}",
          body: attributes.to_json
        )
        if response.code == 200
          JSON.parse(response.body)
        else
          raise response.body
        end
      end

      def destroy(name)
        response = Typhoeus::Request.delete("#{base_uri}/api/v1/users/#{name}")
        response.success? # response.code == 200
      end
    end
  end
