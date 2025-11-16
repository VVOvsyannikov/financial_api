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

        examples 'application/json' => {
          user: {
            email: 'test@example.com',
            balance: 0,
            token: 'jwt.token.here'
          }
        }

        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { { email: 'invalid' } }

        examples 'application/json' => {
          error: 'Validation failed',
          details: [ "Email is invalid" ]
        }

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

        examples 'application/json' => {
          user: {
            email: 'test@example.com',
            balance: 100.0
          }
        }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }

        examples 'application/json' => {
          error: 'Not authorized'
        }

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

        examples 'application/json' => {
          user: {
            email: 'test@example.com',
            balance: 1100.0
          }
        }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        let(:deposit) { { amount: 1000 } }

        examples 'application/json' => {
          error: 'Not authorized'
        }

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

        examples 'application/json' => {
          user: {
            email: 'test@example.com',
            balance: 120.0
          }
        }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        let(:withdraw) { { amount: 1000 } }

        examples 'application/json' => {
          error: 'Not authorized'
        }

        run_test!
      end

      response '422', 'invalid amount or insufficient funds' do
        let(:Authorization) { "Bearer #{token}" }
        let(:withdraw) { { amount: 500 } }

        examples 'application/json' => {
          error: "Insufficient balance",
          details: nil
        }

        run_test!
      end
    end
  end
end
