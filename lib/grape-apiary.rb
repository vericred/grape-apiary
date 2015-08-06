require 'grape'

module GrapeApiary
  autoload :Blueprint,            'grape-apiary/blueprint'
  autoload :Body,            'grape-apiary/body'
  autoload :Config,               'grape-apiary/config'
  autoload :Group,                'grape-apiary/group'
  autoload :Parameter,            'grape-apiary/parameter'
  autoload :Resource,             'grape-apiary/resource'
  autoload :ResponseDescription,  'grape-apiary/response_description'
  autoload :Route,                'grape-apiary/route'
  autoload :SampleGenerator,      'grape-apiary/sample_generator'
  autoload :TemplateRenderer,     'grape-apiary/template_renderer'
  autoload :Version,              'grape-apiary/version'

  def self.config
    block_given? ? yield(Config) : Config
  end
end

class UnsupportedIDType < StandardError
  def message
    'Unsupported id type, supported types are [integer, uuid, bson]'
  end
end

class BSONNotDefinied < StandardError
  def message
    'BSON type id requested but bson library is not present'
  end
end
