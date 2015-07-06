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
        route.route_path.match('\/(\w*)?([\.\/\(]|$)').captures.first
    end

    def initialize(resource, route)
      @resource, @route = resource, route
    end

    def description
      route.route_description
    end

    def detail
      route.route_detail
    end

    def entity
      route.route_entity || route.route_success
    end

    def get?
      http_method == 'GET'
    end

    def http_method
      route.route_method.upcase
    end

    def list?
      !resource.singular?
    end

    def model_name
      resource.try(:title)
    end

    def parameters
      @parameters ||=
        route.route_params
          .sort_by { |k,v| k.to_sym }
          .map { |param| Parameter.new(self, *param) }
    end

    def route_name
      self.class.route_name(self.route)
    end

    def route_binding
      binding
    end

    def visible_parameters
      parameters.select do |param|
        get? || /:#{param.full_name}/ =~ route.route_path
      end
    end

    private

    def request_body?
      !%w(GET DELETE).include?(http_method)
    end
  end
end
