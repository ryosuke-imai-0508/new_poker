require 'rails_helper'

include V1

RSpec.describe 'JudgeAPI', :type => :request do
  describe 'POST api/v1/cards/judge' do

    context 'ステータスコード' do
      context 'エラーがないとき' do
        it '201レスポンスが返ってくること' do
          params = {"cards":["S1,S2,S3,S4,S5"]}
          post '/api/v1/cards/judge', params, as: :json
          expect(response.status).to eq 201
        end
      end

      context 'ユーザーリクエストが不正のとき' do
        it '400レスポンスが返ってくること' do
          params = {"card":["S1,S2,S3,S4,S5"]}
          post '/api/v1/cards/judge', params, as: :json
          expect(response.status).to eq 400
        end
      end

      context 'URLが不正のとき' do
        it '404レスポンスが返ってくること' do
          params = {"cards":["S1,S2,S3,S4,S5"]}
          post '/api/v1/cards/judg', params, as: :json
          expect(response.status).to eq 404
        end
      end

    end

    context 'ボディー' do
      context '正しいリクエストが送られた時' do
        it '適切なボディーを返すこと' do
          params = { "cards": ["S1 S2 S3 S4 S5","S1 S2 S3 S4 S15"] }
          post '/api/v1/cards/judge', params, as: :json
          pattern = {
              "result" => [
                  {
                      "card" => "S1 S2 S3 S4 S5",
                      "hand" => "ストレートフラッシュ",
                      "best" => true
                  }
              ],
              "error" => [
                  {
                      "card" => "S1 S2 S3 S4 S15",
                      "msg" => "5番目のカード指定文字が不正です。(S15)"
                  }
              ]
          }
          expect(JSON.parse(response.body)).to eq(pattern)
        end
      end
    end

  end
end