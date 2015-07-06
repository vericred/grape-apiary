module GrapeApiary
  class Resource
    attr_reader :uri, :name, :routes, :sample_generator

    def initialize(uri, routes)
      @uri = uri
      @name = uri.humanize
      @routes = normalize_routes(routes)
      @sample_generator = SampleGenerator.new(self)
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
      "#{title} [#{route_example_string}]"
    end

    def model_example
      ret = {}
      model.documentation.each_pair do |key, opts|
        ret[key] = opts.fetch(:documentation, {}).fetch(:example, "")
      end

      root = singular? ?
             model.instance_variable_get(:@root) :
             model.instance_variable_get(:@collection_root)

      JSON.unparse({ root  => ret })
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
        methods.include?(route.route_method) && route.route_params.present?
      end

      if potential.present?
        potential.first.route_params
      else
        []
      end
    end

    def resource_binding
      binding
    end

    private

    def model
      routes.map { |route| route.route_entity }.compact.first
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

    def route_example_string
      route = routes.first
      route.route_path_without_format
    end

    def singular?
      routes.first.route_type.to_sym == :single
    end
  end
end
