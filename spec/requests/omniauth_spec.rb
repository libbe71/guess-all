require 'rails_helper'

RSpec.describe "api/omniauth", type: :request doesn
  path '/sessions' do
    post 'Facebook omniauth' do
      tags 'Omniauth'
      consumes 'application/json'
      produces 'application/json'

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
