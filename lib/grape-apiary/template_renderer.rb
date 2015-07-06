module GrapeApiary
  module TemplateRenderer
    #
    # Render an evaluated ERB stringString
    # @param template [String,Symbol]
    # @param context [Binding]
    #
    # @return [String]
    def render(template, context)
      ERB.new(template_for(template), nil, '-')
        .result(context)
    end

    private
    #
    # Fetch a given template from our directory
    #
    # @param name [String,Symbol] Name of the template
    #
    # @return [String] Template contents
    def template_for(name)
      directory = File.dirname(File.expand_path(__FILE__))
      path = File.join(directory, "./templates/#{name}.md.erb")

      File.read(path)
    end
  end
end