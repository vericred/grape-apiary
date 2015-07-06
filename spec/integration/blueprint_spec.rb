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

        ## Widget [/widget/{id}]

        # Group Users

        ## Users [/users]

        ## User [/users/{id}]

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

      #       + id (required, uuid, `26`) ... the `id` of the `widget`





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

      #       + id (required, uuid, `27`) ... the `id` of the `user`



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
