require 'scalingo/provider_api/version'
require 'faraday'
require 'json'

module Scalingo
  class ProviderApi
    API_BASE_URL = 'https://api.scalingo.com/v1'.freeze

    # Will define methods. The method will use the key as a name,
    # and will be configured with the value.
    #
    # Value desc:
    #  * method: HTTP method to call
    #  * path: Parametrized url to call
    #    Parameters can must be valid with the following regex: /:[a-z_]+/
    #    The method will use arguments in the order of appeareance in the url
    #  * body: should this method accept a body?
    METHODS = {
      find_app: { method: :get, path: '/provider/apps/:resource_id' },
      send_config: { method: :post, path: '/addons/:resource_id/config', body: true },
      provision: { method: :post, path: '/addons/:resource_id/provision' }
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
      args << :body if desc[:body]

      raise "Invalid arg count: #{a.length}, expected: #{args.length}" if args.length != a.length

      args.each_with_index do |name, index|
        name="@#{name[1..-1]}" # :abc => @abc

        # Set an instance variable with the arg name
        self.instance_variable_set name.to_s, a[index]

        # Replace the variable name with her value in the path
        path = path.gsub(name.to_s, self.instance_variable_get(name))
      end

      conn = Faraday.new url: @base_url do | conn |
        conn.basic_auth(@user, @password)

        conn.use Faraday::Response::RaiseError
        conn.use Faraday::Adapter::NetHttp
      end

      conn.send(desc[:method], path) do |req|
        req.options.timeout = 30
        req.body = @body
      end
    end
  end
end
