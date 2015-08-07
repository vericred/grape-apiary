require_relative './user_entity'

class SampleApi < Grape::API
  resource 'widgets' do
    desc 'List some Widgets' do
      detail = <<-DOC.gsub(/^ {8}/,'')
        Endpoint to find all Widgets that your account has access
        to.  Just make a GET to

        ```
          widgets = Widget.all
          widgets.map(&:owner) # => ['Spacely\'s Sprockets', ...]
        ```
      DOC
      detail detail
      success [200, 'Widgets']
    end
    get  '/' do
    end

    desc 'Show an Individual Widget' do
      detail 'individual widget'
      success [200, 'Widget']
    end
    get ':id' do
    end

    desc 'Create a Widget' do
      detail 'create a widget'
      success [201, 'Widget']
    end
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

    desc 'Update a Widget' do
      detail 'update a widget'
      success [204, nil]
    end
    params do
      optional :name,
               type: 'string',
               desc: 'the widgets name',
               documentation: { example: 'Foo' }
      optional :description,
               type: 'string',
               desc: 'the widgets description',
               documentation: { example: 'Bar' }
    end
    put  ':id' do
    end

    desc 'Delete a Widget', hidden: true
    delete ':id' do
    end
  end

  resource :users do
    desc 'Display a list of users' do
      success UserEntity
    end
    params do
      optional :page,
               desc: 'Page for pagination',
               type: Integer,
               documentation: { example: 1 }
      optional :per_page,
               desc: 'Number of users per page',
               type: Integer,
               documentation: { example: 10 }
      optional :foo,
               desc: 'This should be hidden',
               type: 'String',
               documentation: { hidden: true }
      optional :bars, type: Array do
        requires :baz,
                 type: Integer,
                 documentation: { example: 50 },
                 desc: 'Baz Description'
        requires :qux,
                 type: Virtus::Attribute::Boolean,
                 documentation: { example: false },
                 desc: 'Qux Description'
      end
    end
    get '/' do
    end

    desc "Display a User", authorizations: { oauth2: [] } do
      success UserEntity
      failure [
                [401, 'Unauthenticated'],
                [403, 'Unauthorized'],
                [404, 'RecordNotFound']
              ]
      detail  <<-DOC.gsub(/^ {14}/,'')
              Users represent registered users for the application
              They are required for authentication and authorization

              This endpoint displays an individual User.
              DOC
    end
    get ':id' do
    end

    desc "Update a User" do
      success [204, 'NoContent']
      failure [
       [401, 'Unauthenticated'],
       [403, 'Unauthorized'],
       [404, 'RecordNotFound'],
       [422, 'RecordInvalid']
      ]
    end
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
