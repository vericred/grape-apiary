class UserEntity < Grape::Entity
  root 'users', 'user'

  expose(
    :id,
    documentation: {
      type: Integer,
      desc: 'Primary key of the user',
      documentation: { example: 1 }
    }
  )

  expose(
    :is_admin,
    documentation: {
      type: Virtus::Attribute::Boolean,
      desc: 'Is this user an admin?',
      documentation: { example: false }
    }
  )
end
