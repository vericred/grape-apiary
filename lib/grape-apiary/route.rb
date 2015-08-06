module GrapeApiary
  class Route
    include TemplateRenderer

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

    def has_request_body?
      %w(POST PUT).include?(http_method)
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

    def post?
      http_method == 'POST'
    end

    def render_response_description(response_description)
      render(
        :response_description,
        response_description.response_description_binding
      )
    end

    def request_body_example
      GrapeApiary::Body.new(request_root, request_body_params)
    end

    def response_descriptions
      responses = [route.route_entity] + (route.route_http_codes || []).compact
      responses.map do |response|
        GrapeApiary::ResponseDescription.new(response, self)
      end
    end

    def route_name
      self.class.route_name(self.route)
    end

    def route_binding
      binding
    end

    def visible_parameters
      parameters.select do |param|
        param.visible? && (get? || /:#{param.full_name}/ =~ route.route_path)
      end
    end

    private

    def raw_request_body_params
      route.route_settings[:description][:params]
    end

    def request_root
      raw_request_body_params
        .select { |k,v| v[:type] == 'Hash'}
        .keys
        .first
    end

    def request_body_params
      return raw_request_body_params if request_root.blank?
      {}.tap do |ret|
        raw_request_body_params.each_pair do |key, param|
          next if param[:type] == 'Hash'
          # convert from foo[bar] to just bar
          ret[key.scan(/\[(.*)\]/).first.try(:first)] = param
        end
      end
    end
  end
end
