class StateEntity < Grape::Entity
  root 'states', 'state'

  expose(
    :id,
    documentation: {
      type: Integer,
      desc: 'Primary key of the state',
      documentation: { example: 1 }
    }
  )

  expose(
    :name,
    documentation: {
      type: String,
      desc: 'Name of the State',
      documentation: { example: 'NY' }
    }
  )
end
