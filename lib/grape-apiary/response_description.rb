module GrapeApiary
  class ResponseDescription
    attr_reader :http_code, :entity_name

    def initialize(route, http_code, entity_name)
      @route, @http_code, @entity_name = route, http_code, entity_name
    end

    def to_s
      ret = "+ Response #{http_code}"
      ret += " (application/json)" if has_body?
      ret += "\n    [#{entity_name}][]" if has_body?
      ret + "\n"
    end

    private

    attr_reader :route

    def has_body?
      [200, 201].include?(http_code.to_i)
    end
  end
end
