require 'spec_helper'

describe GrapeApiary::Blueprint do
  include_context 'configuration'

  before do
    GrapeApiary.config do |config|
      config.host               = host
      config.name               = name
      config.description        = description
      config.resource_exclusion = [:admin]
    end

    GrapeApiary.config.request_headers = [
      { 'Accept-Charset' => 'utf-8' },
      { 'Connection'     => 'keep-alive' }
    ]

    GrapeApiary.config.response_headers = [
      { 'Content-Length' => '21685' },
      { 'Connection'     => 'keep-alive' }
    ]
  end

  subject { GrapeApiary::Blueprint.new(SampleApi) }

  context '#generate' do
    let(:klass) { SampleApi }

    subject { GrapeApiary::Blueprint.new(klass).generate }

    it 'sets the format to 1A' do
      expect(subject).to include('1A')
    end

    it 'sets the host based on configuration' do
      expect(subject).to include("HOST: #{host}")
    end

    it 'creates a header from configuration' do
      expect(subject).to include("# #{name}")
    end

    it 'adds the description' do
      expect(subject).to include(description)
    end

    it 'includes groups for each resource' do
      expect(subject).to include('# Group Widgets')
    end

    xit 'includes properties for the resources' do
      expect(subject).to include('Properties')
    end

    it 'is the full correct resource definition' do
      normalized = subject.gsub(/ +$/,'')
      expected = <<-DEF.gsub(/^ {8}/,'')
        FORMAT: 1A
        HOST: http://grape-apiary.apiary.io

        # some api v1
        some blueprint description

        # Group Widgets

        ## Widgets [/widgets]

        ### List some Widgets  [GET]

        Endpoint to find all Widgets that your account has access
        to.  Just make a GET to

        ```
          widgets = Widget.all
          widgets.map(&:owner) # => ['Spacely's Sprockets', ...]
        ```

        ### Create a Widget  [POST]

        create a widget

        ## Widget [/widgets/{id}]

        ### Show an Individual Widget  [GET]

        individual widget

        + Parameters
            + id (required, integer, `1`) ... the `id` of the `Widget`

        ### Update a Widget  [PUT]

        update a widget

        + Parameters
            + id (required, integer, `1`) ... the `id` of the `Widget`

        # Group Users

        ## Users [/users{?page,per_page}]

        Properties

        | Name | Type | Description |
        |:-----|:-----|:------------|
        | id |  Integer | Primary key of the user |
        | is_admin |  Boolean | Is this user an admin? |

        ### Display a list of users  [GET]

        + Parameters
            + page (optional, Integer, `1`) ... Page for pagination
            + per_page (optional, Integer, `10`) ... Number of users per page

        + Response

                {"users":[{"id":1,"is_admin":false}]}

        ## User [/users/{id}]

        Properties

        | Name | Type | Description |
        |:-----|:-----|:------------|
        | id |  Integer | Primary key of the user |
        | is_admin |  Boolean | Is this user an admin? |

        ### Display a User  [GET]

        Users represent registered users for the application
        They are required for authentication and authorization

        This endpoint displays an individual User.

        + Parameters
            + id (required, integer, `1`) ... the `id` of the `User`

        + Response

                {"user":{"id":1,"is_admin":false}}

        ### Update a User  [PUT]

        + Parameters
            + id (required, integer, `1`) ... the `id` of the `User`

        + Response

                {"user":{"id":1,"is_admin":false}}

      DEF
      #   ## Widgets [/widgets]

      #   Actions on the Widgets resource




      #   ### widgets list [GET]

      #   + Response 200 (application/json)
      #       [Widgets][]


      #   ### create a widget [POST]

      #   + Request (application/json)
      #       + Headers

      #               Accept-Charset: utf-8
      #               Connection: keep-alive
      #       + Body

      #                 {
      #                   "description": "the best widget ever made",
      #                   "name": "super widget"
      #                 }

      #   + Response 201 (application/json)
      #       [Widget][]



      #   ## Widget [/widgets/:id]

      #   Actions on the Widgets resource

      #   + Parameters

      #       + id (required, uuid, `26`) ... the `id` of the `Widget`





      #   ### individual widget [GET]

      #   + Response 200 (application/json)
      #       [Widget][]


      #   ### update a widget [PUT]

      #   + Request (application/json)
      #       + Headers

      #               Accept-Charset: utf-8
      #               Connection: keep-alive
      #       + Body

      #                 {
      #                   "description": "the best widget ever made",
      #                   "name": "super widget"
      #                 }

      #   + Response 204





      #   # Group User
      #   Properties

      #   | Name | Type | Description |
      #   |:-----|:-----|:------------|
      #   | id |  Integer | Primary key of the user |
      #   | is_admin |  Boolean | Is this user an admin? |




      #   ## User [/users/:id]

      #   Actions on the Users resource

      #   + Parameters

      #       + id (required, uuid, `27`) ... the `id` of the `User`



      #   + Model (application/json)
      #       + Body

      #           {"user":{"id":1,"is_admin":false}}



      #   ### Display a user [GET]
      #   Users represent registered users for the application
      #   They are required for authentication and authorization

      #   This endpoint displays an individual User.


      #   + Response 201 (application/json)
      #       [User][]

      #   + Response 401

      #   + Response 403

      #   + Response 404


      #   ### Update a user [PUT]

      #   + Request (application/json)
      #       + Headers

      #               Accept-Charset: utf-8
      #               Connection: keep-alive
      #       + Body

      #                 {
      #                   "id": 28,
      #                   "is_admin": false
      #                 }

      #   + Response 204

      #   + Response 401

      #   + Response 403

      #   + Response 404

      #   + Response 422





      # DEF
      expect(normalized).to eql(expected)
    end
  end

  it 'exposes configuration settings' do
    GrapeApiary::Config::SETTINGS.each do |setting|
      expect(subject.send(setting)).to eq(GrapeApiary.config.send(setting))
    end
  end
end
