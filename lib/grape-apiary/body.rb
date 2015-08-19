module GrapeApiary
  class Body
    def initialize(root, definition, singular = true)
      @root, @definition, @singular = root, definition, singular
    end

    def to_s
      ret = {}
      @definition.each_pair do |key, opts|
        ret[key] = opts[:example] ||
                   opts.fetch(:documentation, {}).fetch(:example, "")
      end
      ret = [ret] unless @singular
      ret = { @root => ret } if @root.present?
      JSON.unparse(ret)
    end
  end
end
