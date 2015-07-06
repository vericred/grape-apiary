module GrapeApiary
  class Blueprint
    attr_reader :api_class

    include TemplateRenderer

    delegate(*GrapeApiary::Config::SETTINGS, to: 'GrapeApiary::Config')

    def initialize(api_class)
      @api_class = api_class
    end

    def groups
      @groups ||= begin
        api_class.routes
          .group_by { |route| GrapeApiary::Group.fetch_name(route) }
          .reject { |name, routes| resource_exclusion.include?(name.to_sym) }
          .map { |name, routes| GrapeApiary::Group.new(name, routes) }
      end
    end

    def generate
      render(:blueprint, binding)
    end

    def write
      fail 'Not yet supported'
    end

    def routes
      resources.map(&:routes).flatten
    end

    def resources
      @resources ||= begin
        api_class.routes
          .group_by { |route| GrapeApiary::Route.route_name(route) }
          .reject { |name, routes| resource_exclusion.include?(name.to_sym) }
          .map { |name, routes| Resource.new(name, routes) }
      end
    end

    def render_group(group)
      render(:group, group.group_binding)
    end

    def properties_table(resource)
      ERB.new(properties_template, nil, '-')
        .result(resource.resource_binding)
    end

    def formatted_request_headers
      formatted_headers(GrapeApiary::Config.request_headers)
    end

    def formatted_response_headers
      formatted_headers(GrapeApiary::Config.response_headers)
    end

    def show_request_sample?(route)
      %w(PUT POST).include?(route.route_method)
    end

    private

    def formatted_headers(headers)
      return '' unless headers.present?

      spacer  = "\n" + (' ' * 12)

      strings = headers.map do |header|
        key, value = *header.first

        "#{key}: #{value}"
      end

      "    + Headers\n" + spacer + strings.join(spacer)
    end
  end
end
