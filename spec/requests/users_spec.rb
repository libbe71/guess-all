require 'swagger_helper'

RSpec.describe 'api/user', type: :request do

  path '/users' do
    post 'Creates a user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          username: { type: :string, example: 'john_doe' },
          name: { type: :string, example: 'John' },
          surname: { type: :string, example: 'Doe'},
          birthdate: { type: :string, format: 'date' },
          phone_number: { type: :string, example: '1234567890'},
          email_address: { type: :string, example: 'johndoe@ex.it'},
          password_digest: { type: :string, example: 'password'},
          state: { type: :string, example: 'italy' },
          city: { type: :string, example: 'rome'},
          address: { type: :string, example: 'via roma 1'}  
        },
        required: [ 'username', 'name', 'surname', 'birthdate', 'phone_number', 'email_address', 'password_digest', 'state', 'city', 'address' ]
      }

      response '201', 'user created' do
        let(:user) { { username: 'foo', name: 'bar', surname: 'baz', birthdate: '2000-01-01', phone_number: '1234567890', email_address: 'foo@bar.com', password_digest: 'foobar', state: 'foo', city: 'bar', address: 'baz' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { { username: 'foo' } }
        run_test!
      end
    end

    get 'Retrieves all users' do
      tags 'Users'
      produces 'application/json'

      response '200', 'Users found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :string },
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
            required: [ 'id', 'username', 'name', 'surname', 'birthdate', 'phone_number', 'email_address', 'password_digest', 'state', 'city', 'address', 'created_at', 'updated_at' ]
          }
        run_test!
      end

      response '404', 'no table users found' do
        run_test!
      end
    end
  end

  path '/users/{id}' do
    get 'Retrieves a user' do
      tags 'Users'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'user found' do
        schema type: :object,
          properties: {
            id: { type: :string },
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

    put 'Updates a user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          username: { type: :string },
          name: { type: :string },
          surname: { type: :string },
          birthdate: { type: :string, format: 'date' },
          phone_number: { type: :string },
          email_address: { type: :string },
          password_digest: { type: :string },
          state: { type: :string },
          city: { type: :string },
          address: { type: :string }
        }
      }

      response '200', 'user updated' do
        let(:user) { { username: 'foo_updated' } }
        run_test!
      end

      response '404', 'user not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    delete 'Deletes a user' do
      tags 'Users'
      parameter name: :id, in: :path, type: :integer

      response '200', 'user deleted' do
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
