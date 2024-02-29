require 'swagger_helper'

RSpec.describe 'api/user', type: :request do

  path '/users/{id}' do

    get 'Retrieves a user' do
      tags 'Users'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'user found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            username: { type: :string },
            name: { type: :string },
            surname: { type: :string },
            birthdate: { type: :string, format: 'date' },
            phone_number: { type: :string },
            email_address: { type: :string },
            password_digest: { type: :string },
            state: { type: :string },
            city: { type: :string },
            address: { type: :string },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' }
          },
          required: [ 'id', 'username', 'name', 'surname', 'birthdate', 'phone_number', 'email_address', 'password_digest', 'state', 'city', 'address' ]

        let(:id) { User.create(username: 'foo', name: 'bar', surname: 'baz', birthdate: '2000-01-01', phone_number: '1234567890', email_address: 'foo@bar.com', password_digest: 'foobar', state: 'foo', city: 'bar', address: 'baz').id }
        run_test!
      end

      response '404', 'user not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
