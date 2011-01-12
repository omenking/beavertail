class User
  after_create :create_role
end