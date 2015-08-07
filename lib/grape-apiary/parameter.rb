module GrapeApiary
  class Parameter
    attr_reader :route, :name, :settings

    delegate :route_model, :route_namespace, to: :route
    delegate :requirement, :type, :documentation, :desc, to: :settings
    delegate :example, :hidden, to: :documentation, allow_nil: true

    def initialize(route, name, options)
      @name = name.to_s
      @route     = route
      @settings  = parse_options(options)
    end

    def description
      "#{CGI.escape(full_name)} (#{requirement}, " \
      "#{type}, `#{example}`) ... #{desc}"
    end

    def full_name
      @full_name ||= begin
        if name =~ /\[/ && nested_array?
          parts = name.split('[')
          "#{parts[0]}[][#{parts[1]}"
        else
          name
        end
      end
    end

    def optional?
      !required?
    end

    def required?
      settings.requireda
    end

    def type
      case @settings.type
      when 'Virtus::Attribute::Boolean'
        'Boolean'
      else
        @settings.type
      end
    end

    def visible?
      !hidden && !['array', 'hash'].include?(type.to_s.downcase)
    end

    private

    def build_full_name(name)
      route.parmeters
    end

    def nested_array?
      parent_parameter.present? &&
        parent_parameter.type.to_s.downcase == 'array'
    end

    def parent_parameter
      return nil unless name =~ /\[/
      route.parameters.find { |param| param.name == name.scan(/^\w+/).first }
    end

    def parse_options(options)
      options = default_options(options) if options.blank?
      Hashie::Mash.new(options)
    end

    def requirement
      return 'optional' unless settings.required
      return 'optional' if parent_parameter.try(:optional?)
      'required'
    end

    def default_options(options)
      {
        required:       true,
        requirement:    'required',
        type:           'integer',
        desc:           "the `id` of the `#{route.model_name}`",
        documentation:  {
          example:     1
        }
      }
    end
  end
end
