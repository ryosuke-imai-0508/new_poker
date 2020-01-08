module API
  class Base < Grape::API
    prefix :api
    format :json

#   400の時（ユーザーのリクエストの形がおかしい。インプットがおかしい。）
    rescue_from Grape::Exceptions::Base do
      error!({msg: "400 Bad Request：不正なリクエストです。"}, 400)
    end
#   404の時（URLの形がおかしい。パスがおかしい。）
    route :any, '*path' do
      error!({msg: "404 Not Found：不正なURLです。"}, 404)
    end

#   500の時（それ以外の予期しないエラー）
    rescue_from Exception do
      error!({msg: "500 Internal Server Error：予期しないエラーです。"}, 500)
    end

    mount API::V1::RootAPI
  end
end