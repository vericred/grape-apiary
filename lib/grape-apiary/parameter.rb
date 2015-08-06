module GrapeApiary
  class Parameter
    attr_reader :route, :full_name, :name, :settings

    delegate :route_model, :route_namespace, to: :route
    delegate :requirement, :type, :documentation, :desc, to: :settings
    delegate :example, :hidden, to: :documentation, allow_nil: true

    def initialize(route, name, options)
      name = name.to_s
      @full_name = name
      @name      = name
      @name      = name.scan(/\[(.*)\]/).flatten.first if name.include?('[')
      @route     = route
      @settings  = parse_options(options)
    end

    def description
      "#{name} (#{requirement}, #{type}, `#{example}`) ... #{desc}"
    end

    def type
      case @settings.type
      when 'Virtus::Attribute::Boolean'
        'boolean'
      else
        @settings.type
      end
    end

    def visible?
      !hidden
    end

    private

    def parse_options(options)
      options = default_options(options) if options.blank?

      options[:requirement] = options[:required] ? 'required' : 'optional'

      Hashie::Mash.new(options)
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
