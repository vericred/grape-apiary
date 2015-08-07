module GrapeApiary
  class Resource
    include TemplateRenderer

    attr_reader :uri, :name, :routes, :sample_generator

    def initialize(uri, routes)
      @uri = uri
      @name = uri.split('/').reject(&:blank?).first.humanize
      @routes = normalize_routes(routes)
      @sample_generator = SampleGenerator.new(self)
    end

    def collection?
      !singular?
    end

    def documentation
      model.try(:documentation).presence || {}
    end

    def title
      @title ||= begin
        if singular?
          name.singularize.titleize
        else
          name.pluralize.titleize
        end
      end
    end

    def namespaced
      @namespaced ||= routes.group_by(&:route_namespace).map do |_, routes|
        Resource.new(name, routes)
      end
    end

    def paths
      @paths ||= routes.group_by(&:route_path_without_format).map do |n, routes|
        Resource.new(name, routes)
      end
    end

    def has_model?
      model.present?
    end

    def header
      "#{title} [#{uri_with_parameters}]"
    end

    def sample_request
      sample_generator.request
    end

    def sample_response(route)
      sample_generator.response(route.list?)
    end

    def unique_params
      # TODO: this is a hack, assuming that the resource has a POST or PUT
      # route that defines all of the parameters that would define the resource
      methods = %w(POST PUT)

      potential = routes.select do |route|
        methods.include?(route.route_method) && route.parameters.present?
      end

      if potential.present?
        potential.first.parameters
      else
        []
      end
    end

    #
    # Render our Route via a template
    # @param route [GrapeApiary::Route]
    #
    # @return [String]
    def render_route(route)
      render(:route, route.route_binding)
    end

    #
    # Make our binding more public
    #
    # @return [Binding]
    def resource_binding
      binding
    end

    #
    # Is this a singular resource or a collection?
    #
    # @return [Boolean]
    def singular?
      !!(uri =~ /\{id\}/)
    end

    private

    def model
      routes.map(&:entity).compact.first
    end

    #
    # Helper method to make sure our routes are GrapeApiary::Routes
    #
    def normalize_routes(routes)
      routes.map do |route|
        route = route.route if route.is_a?(GrapeApiary::Route)
        GrapeApiary::Route.new(self, route)
      end
    end

    #
    # The route parameters for all GET requests
    #
    # @return [Array<String>]
    def params_for_gets
      param_set = routes
        .select { |r| r.http_method == 'GET'}
        .map { |r| r.parameters.select(&:visible?).map(&:full_name) }
        .flatten
        .compact
        .map { |p| CGI.escape(p) }
        .sort
    end

    #
    # Returns a URI with all of the possible query params present
    #
    # @return [String]
    def uri_with_parameters
      ret = uri.clone
      if collection? && params_for_gets.present?
        ret += "{?#{params_for_gets.join(',')}}"
      end
      ret
    end
  end
end
