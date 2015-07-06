require_relative './user_entity'

class SampleApi < Grape::API
  resource 'widgets' do
    desc 'widgets list',
         http_codes: [
          [200, 'Widgets']
         ]
    get  '/' do
    end

    desc 'individual widget',
         http_codes: [
          [200, 'Widget']
         ]
    get ':id' do
    end

    desc 'create a widget',
         http_codes: [
          [201, 'Widget']
         ]
    params do
      requires :name,
               type: 'string',
               desc: 'the widgets name',
               documentation: { example: 'super widget' }
      optional :description,
               type: 'string',
               desc: 'the widgets name',
               documentation: { example: 'the best widget ever made' }
    end
    post '/' do
    end

    desc 'update a widget',
         http_codes: [[204, nil]]
    params do
      optional :name, type: 'string', desc: 'the widgets name'
      optional :description, type: 'string', desc: 'the widgets name'
    end
    put  ':id' do
    end
  end

  resource :users do
    desc 'Display a list of users',
         http_codes: [
          [200, 'Users'],
          [401, 'Unauthenticated'],
          [403, 'Unauthorized']
         ]
    params do
      optional :page, desc: 'Page for pagination', type: Integer
      optional :per_page, desc: 'Number of users per page', type: Integer
    end
    get '/' do
    end

    desc "Display a user",
         entity: UserEntity,
         http_codes: [
           [201, 'User'],
           [401, 'Unauthenticated'],
           [403, 'Unauthorized'],
           [404, 'RecordNotFound']
         ],
         authorizations: { oauth2: [] },
         docs: <<-DOC.gsub(/^ {15}/,'')
               Users represent registered users for the application
               They are required for authentication and authorization

               This endpoint displays an individual User.
               DOC
    get ':id' do
    end

    desc "Update a user",
         http_codes: [
           [204, 'NoContent'],
           [401, 'Unauthenticated'],
           [403, 'Unauthorized'],
           [404, 'RecordNotFound'],
           [422, 'RecordInvalid']
         ]
    params do
      requires :user, type: Hash do
        requires :all, using: UserEntity.documentation.except(:id)
      end
    end
    put ':id' do
    end
  end

  resource 'admin' do
    get '/' do
    end
  end
end
