module API
  module V1
    class RootAPI < Grape::API
      version 'v1'
      format :json

      mount API::V1::JudgeAPI
    end
  end
end
