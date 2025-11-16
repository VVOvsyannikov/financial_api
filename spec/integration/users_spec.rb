require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  let!(:user) { create(:user, balance: 100) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }

  path '/api/v1/users' do
    post 'Creates a user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: { email: { type: :string, example: 'test@example.com' } },
        required: [ 'email' ]
      }

      response '201', 'user created' do
        let(:user) { { email: 'test@example.com' } }

        include_examples 'user_created_example'
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { { email: 'invalid' } }

        include_examples 'validation_error_example'
        run_test!
      end
    end
  end

  path '/api/v1/users/balance' do
    get 'Returns user balance' do
      tags 'Users'
      produces 'application/json'
      security [ bearerAuth: [] ]

      response '200', 'balance info' do
        let(:Authorization) { "Bearer #{token}" }

        include_examples 'user_info_example'
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }

        include_examples 'unauthorized_error_example'
        run_test!
      end
    end
  end

  path '/api/v1/users/deposit' do
    post 'Deposit amount to user balance' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      security [ bearerAuth: [] ]

      parameter name: :deposit, in: :body, schema: {
        type: :object,
        properties: {
          amount: { type: :number, example: 1000 }
        },
        required: [ 'amount' ]
      }

      response '200', 'balance updated' do
        let(:Authorization) { "Bearer #{token}" }
        let(:deposit) { { amount: 1000 } }

        include_examples 'user_info_example'
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        let(:deposit) { { amount: 1000 } }

        include_examples 'unauthorized_error_example'
        run_test!
      end
    end
  end

  path '/api/v1/users/withdraw' do
    post 'Withdraw amount from user balance' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      security [ bearerAuth: [] ]

      parameter name: :withdraw, in: :body, schema: {
        type: :object,
        properties: {
          amount: { type: :number, example: 20.0 }
        },
        required: [ 'amount' ]
      }

      response '200', 'balance updated' do
        let(:Authorization) { "Bearer #{token}" }
        let(:withdraw) { { amount: 20 } }

        include_examples 'user_info_example'
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        let(:withdraw) { { amount: 1000 } }

        include_examples 'unauthorized_error_example'
        run_test!
      end

      response '422', 'invalid amount or insufficient funds' do
        let(:Authorization) { "Bearer #{token}" }
        let(:withdraw) { { amount: 500 } }

        include_examples 'insufficient_funds_example'
        run_test!
      end
    end
  end
end
