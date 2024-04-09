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
  path '/sessions/refresh' do
    post 'Refreshes a session token' do
      tags 'Sessions'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :session, in: :body, schema: {
        type: :object,
        properties: {
              refresh_token: { type: :string, example: 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.z7qJczsfi1j8zrFPlwBGLX5v3Hac4' }
        },
        required: [ 'refresh_token' ]
      }

      response '200', 'session refreshed' do
        examples 'application/json' =>  {
          token: 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.z7qJczsfi1j8zrFPlwBGLX5v3Hac4'
        }

        run_test!
      end

      response '400', 'bad request' do
        examples 'application/json' =>  {
          error: 'Bad request'
        }

        run_test!
      end
    end
  end
end
