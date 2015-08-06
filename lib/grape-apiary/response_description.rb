module GrapeApiary
  class ResponseDescription
    attr_reader :route

    def initialize(entity, route)
      @entity, @route = entity, route
    end

    def response_description_binding
      binding
    end

    def response_body
      return nil if entity.try(:documentation).blank?
      root = singular? ?
             entity.instance_variable_get(:@root) :
             entity.instance_variable_get(:@collection_root)

      GrapeApiary::Body.new(root, entity.documentation, singular?)
    end

    def response_code
      @entity.try(:first) || 200
    end

    private

    attr_reader :route, :entity

    def collection?
      !singular?
    end

    def entity
      @entity.is_a?(Array) ? @entity.last : @entity
    end

    def singular?
      route.route_path =~ /\:id/ || route.post?
    end

  end
end
