RSpec.shared_examples 'unauthorized_error_example' do
  examples 'application/json' => {
    error: 'Not authorized'
  }
end

RSpec.shared_examples 'validation_error_example' do
  examples 'application/json' => {
    error: 'Validation failed',
    details: [ "Email is invalid" ]
  }
end

RSpec.shared_examples 'user_created_example' do
  examples 'application/json' => {
    user: {
      email: 'test@example.com',
      balance: 0,
      token: 'jwt.token.here'
    }
  }
end

RSpec.shared_examples 'user_info_example' do
  examples 'application/json' => {
    user: {
      email: 'test@example.com',
      balance: 100.0
    }
  }
end

RSpec.shared_examples 'insufficient_funds_example' do
  examples 'application/json' => {
    error: "Insufficient balance",
    details: nil
  }
end