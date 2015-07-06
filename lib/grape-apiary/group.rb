module GrapeApiary
  class Group
    include TemplateRenderer

    #
    # Normalize the name of a Route for a Group
    # @param route [Grape::Route]
    #
    # @return [String] Name
    def self.fetch_name(route)
      route.route_namespace.split('/').last ||
        route.route_path.match('\/(\w*)?([\.\/\(]|$)').captures.first
    end

    #
    # Constructor
    #
    # @param namespace [String] Namespace for the Group
    # @param routes [Array<Grape::Route>] List of Routes under the Group
    #
    def initialize(namespace, routes)
      @namespace, @routes = namespace, routes
    end

    #
    # Publicizing binding
    #
    # @return [Binding]
    def group_binding
      binding
    end

    #
    # Render our template for our resource
    # @param resource [GrapeApiary::Resource]
    #
    # @return [String]
    def render_resource(resource)
      render(:resource, resource.resource_binding)
    end

    #
    # List of Resources within this group
    #
    # @return [Array<GrapeApiary::Resource>]
    def resources
      routes.group_by { |route| normalize_uri(route) }
        .map { |uri, routes| GrapeApiary::Resource.new(uri, routes)}
    end

    #
    # Title to display for this Group
    #
    # @return [String]
    def title
      namespace.to_s.titleize
    end

    private

    attr_reader :namespace, :routes

    #
    # Format a URI for our purposes
    # @param route [type] [description]
    #
    # @return [type] [description]
    def normalize_uri(route)
      route.route_path
        .gsub('(.:format)','')
        .gsub(/:(\w+)/, '{\1}')
    end
  end
end