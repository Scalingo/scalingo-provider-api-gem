require 'scalingo/provider_api/version'
require 'faraday'
require 'json'

module Scalingo
  module ProviderApi
    class Client
      API_BASE_URL = 'https://api.scalingo.com/'.freeze

      # Will define methods. The method will use the key as a name,
      # and will be configured with the value.
      #
      # Value desc:
      #  * method: HTTP method to call
      #  * path: Parametrized url to call
      #    Parameters can must be valid with the following regex: /:[a-z_]+/
      #    The method will use arguments in the order of appeareance in the url
      #  * body: should this method accept a body?
      #  * body_hook: lambda function that will transform the body
      METHODS = {
        find_app: { method: :get, path: '/v1/provider/apps/:resource_id' },
        send_config: { method: :patch, path: '/v1/provider/addons/:resource_id/config', body: true, body_hook: lambda {|b| {config: b}}},
        provision: { method: :post, path: '/v1/provider/addons/:resource_id/actions/provision' }
      }.freeze

      def initialize(user, password, args = {})
        @user = user
        @password = password

        @base_url = API_BASE_URL
        @base_url = args[:base_url] if !args[:base_url].nil?
      end

      def method_missing(met, *a)
        return if METHODS[met].nil?
        desc = METHODS[met]
        path = desc[:path]

        # Find all arguments.
        # http://a.fr/:a/b/:c/:a => [:a, :c]
        args = path.scan(/:[a-z_]+/).uniq

        # If we need a body add :body to the list of arguments
        args << ':body' if desc[:body]

        raise "Invalid arg count: #{a.length}, expected: #{args.length}" if args.length != a.length

        args.each_with_index do |name, index|
          old_name = name
          name = "@#{name[1..-1]}" # :abc => @abc

          # Set an instance variable with the arg name
          instance_variable_set name.to_s, a[index]

          if name != '@body'
            # Replace the variable name with its value in the path
            path = path.gsub(old_name.to_s, instance_variable_get(name))
          end
        end

        conn = Faraday.new url: @base_url do |c|
          c.basic_auth(@user, @password)

          c.use Faraday::Response::RaiseError
          c.use Faraday::Adapter::NetHttp
        end

        @body = desc[:body_hook].call @body if !desc[:body_hook].nil?

        res = conn.send(desc[:method], path) do |req|
          req.headers['Content-Type'] = 'application/json'
          req.options.timeout = 30
          req.body = @body.to_json
        end
        return JSON.parse res.body
      end
    end
  end
end
