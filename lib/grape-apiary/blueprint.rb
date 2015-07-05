module GrapeApiary
  class Blueprint
    attr_reader :api_class, :blueprint_template, :properties_template

    delegate(*GrapeApiary::Config::SETTINGS, to: 'GrapeApiary::Config')

    def initialize(api_class)
      @api_class           = api_class
      @blueprint_template  = template_for(:blueprint)
      @properties_template = template_for(:properties)
    end

    def generate
      ERB.new(blueprint_template, nil, '-').result(binding)
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

    def template_for(name)
      directory = File.dirname(File.expand_path(__FILE__))
      path = File.join(directory, "./templates/#{name}.md.erb")

      File.read(path)
    end

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
