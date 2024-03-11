require 'swagger_helper'

RSpec.describe 'api/user', type: :request do
  path '/users' do
    post 'Creates a user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              username: { type: :string, example: 'john_doe' },
              name: { type: :string, example: 'John' },
              surname: { type: :string, example: 'Doe'},
              birthdate: { type: :string, format: 'date' },
              phone_number: { type: :string, example: '1234567890'},
              email_address: { type: :string, example: 'johndoe@ex.it'},
              password: { type: :string, example: 'password'},
              state: { type: :string, example: 'italy' },
              city: { type: :string, example: 'rome'},
              address: { type: :string, example: 'via roma 1'}  
            },
            required: [ 'username', 'name', 'surname', 'birthdate', 'phone_number', 'email_address', 'password', 'state', 'city', 'address' ]
          }
        }
      }

      response '201', 'user created' do
        examples 'application/json' => {
          id: 1,
          username: 'foo',
          name: 'bar',
          surname: 'baz',
          birthdate: '2000-01-01',
          phone_number: '1234567890',
          email_address: 'foo@bar.com',
          password: 'foobar',
          state: 'foo',
          city: 'bar',
          address: 'baz',
          created_at: '2024-03-10T12:00:00Z',
          updated_at: '2024-03-10T12:00:00Z'
        }

        run_test!
      end

      response '422', 'invalid request' do
        examples 'application/json' => {
          errors: ['Password can\'t be blank', 'Email address can\'t be blank']
        }

        run_test!
      end
    end

    get 'Retrieves all users' do
      tags 'Users'
      produces 'application/json'

      response '200', 'Users found' do
        examples 'application/json' => [
          {
            id: 1,
            username: 'foo',
            name: 'bar',
            surname: 'baz',
            birthdate: '2000-01-01',
            phone_number: '1234567890',
            email_address: 'foo@bar.com',
            password: 'foobar',
            state: 'foo',
            city: 'bar',
            address: 'baz',
            created_at: '2024-03-10T12:00:00Z',
            updated_at: '2024-03-10T12:00:00Z'
          },
          # Add more examples if needed
        ]

        run_test!
      end

      response '404', 'no table users found' do
        examples 'application/json' => {
          error: 'No users found'
        }

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
        examples 'application/json' => {
          id: 1,
          username: 'foo',
          name: 'bar',
          surname: 'baz',
          birthdate: '2000-01-01',
          phone_number: '1234567890',
          email_address: 'foo@bar.com',
          password: 'foobar',
          state: 'foo',
          city: 'bar',
          address: 'baz',
          created_at: '2024-03-10T12:00:00Z',
          updated_at: '2024-03-10T12:00:00Z'
        }

        run_test!
      end

      response '404', 'user not found' do
        examples 'application/json' => {
          error: 'User not found'
        }

        run_test!
      end
    end

    put 'Updates a user' do
      tags 'Users'
      
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              username: { type: :string },
              name: { type: :string },
              surname: { type: :string },
              birthdate: { type: :string, format: 'date' },
              phone_number: { type: :string },
              email_address: { type: :string },
              password: { type: :string },
              state: { type: :string },
              city: { type: :string },
              address: { type: :string }
            }
          }
        }
      }

      response '200', 'user updated' do
        examples 'application/json' => {
          message: 'User updated successfully'
        }

        run_test!
      end

      response '404', 'user not found' do
        examples 'application/json' => {
          error: 'User not found'
        }

        run_test!
      end
    end

    delete 'Deletes a user' do
      tags 'Users'
      parameter name: :id, in: :path, type: :integer

      response '200', 'user deleted' do
        examples 'application/json' => {
          message: 'User deleted successfully'
        }

        run_test!
      end

      response '404', 'user not found' do
        examples 'application/json' => {
          error: 'User not found'
        }

        run_test!
      end
    end
  end
end
