require 'json'

module Bamboo
  module Client
    module Http
      class Json < Abstract
        def post(path, data = {})
          resp = RestClient.post(uri_for(path), data.to_json, :accept => :json, :content_type => :json)
          Doc.from(resp) unless resp.empty?
        end

        def get(path)
          Doc.from RestClient.get(uri_for(path), :accept => :json)
        end

        class Doc
          def self.from(str)
            new JSON.parse(str)
          end

          def initialize(data)
            @data = data
          end

          def expand(key, klass)
            @data.fetch(key).map { |e| klass.new(e) }
          end
        end
      end # Json
    end # Http
  end # Client
end # Bamboo
