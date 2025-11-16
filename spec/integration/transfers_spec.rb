require 'swagger_helper'

RSpec.describe 'Transfers API', type: :request do
  let!(:sender) { create(:user, balance: 100) }
  let!(:receiver) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: sender.id) }

  path '/api/v1/transfers' do
    post 'Creates a transfer' do
      tags 'Transfers'
      consumes 'application/json'
      produces 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :transfer, in: :body, schema: {
        type: :object,
        properties: {
          receiver_email: { type: :string },
          amount: { type: :number }
        },
        required: [ 'receiver_email', 'amount' ]
      }

      response '200', 'transfer created' do
        let(:Authorization) { "Bearer #{token}" }
        let(:transfer) { { receiver_email: receiver.email, amount: 100 } }

        include_examples 'user_info_example'
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        let(:transfer) { { receiver_email: receiver.email, amount: 100 } }

        include_examples 'unauthorized_error_example'
        run_test!
      end

      response '422', 'invalid params' do
        let(:Authorization) { "Bearer #{token}" }
        let(:transfer) { { receiver_email: 'invalid' } }

        examples 'application/json' => {
          error: 'Receiver not found',
          details: nil
        }

        run_test!
      end
    end
  end
end
