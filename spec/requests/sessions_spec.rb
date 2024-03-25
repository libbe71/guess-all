require 'swagger_helper'

RSpec.describe 'api/session', type: :request do
  path '/sessions' do
    post 'Creates a session' do
      tags 'Sessions'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :session, in: :body, schema: {
        type: :object,
        properties: {
          session: {
            type: :object,
            properties: {
              email: { type: :string, example: 'johndoe@ex.it' }, 
              password: { type: :string, example: 'password' }
            },
            required: [ 'email', 'password' ]
          }
        }
      }

    response '201', 'session created' do
      examples 'application/json' =>  {
        token: 'eyJhbGci  ...  9.eyJ1c2VyX2lkIjoxfQ'  
      }
      
      run_test!
    end

    response '404', 'session denied' do
      examples 'application/json' =>  {
         error: 'Invalid email or password'  
      }

      run_test!
    end
    end
  end
end
