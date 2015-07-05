module GrapeApiary
  class Route
    # would like to rely on SimpleDelegator but Grape::Route uses
    # method_missing for these methods :'(
    delegate(
      :route_entity,
      :route_namespace,
      :route_path,
      :route_method,
      :route_docs,
      :route_http_codes,
      to: :route
    )

    attr_reader :route, :resource

    #
    # Helper method to normalize a route name
    # This is used to group routes into resources
    #
    def self.route_name(route)
      route.route_namespace.split('/').last ||
        route.route_path.match('\/(\w*?)[\.\/\(]').captures.first
    end

    def initialize(resource, route)
      @resource, @route = resource, route
    end

    def resource_title
      resource.title
    end

    def response_descriptions
      (route_http_codes.presence || [[200, resource.title]])
        .map { |code| ResponseDescription.new(self, *code)}
    end

    def route_params
      @route_params ||=
        route.route_params
          .sort_by { |k,v| k.to_sym }
          .map { |param| Parameter.new(self, *param) }
    end

    def route_name
      self.class.route_name(self.route)
    end

    def route_description
      "#{route.route_description} [#{route_method.upcase}]"
    end

    def route_path_without_format
      route_path.gsub(/\((.*?)\)/, '')
    end

    def route_model
      route_namespace.split('/').last.singularize
    end

    def route_type
      list? ? 'collection' : 'single'
    end

    def request_description
      "+ Request #{'(application/json)' if request_body?}"
    end

    def list?
      %w(GET POST).include?(route_method) && !route_path.include?(':id')
    end

    private

    def request_body?
      !%w(GET DELETE).include?(route_method)
    end
  end
end
