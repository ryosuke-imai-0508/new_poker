require 'rails_helper'

RSpec.describe HomeController, type: :controller  do

  describe '#top' do

    it '200レスポンスが返ってきているか' do
      get :top
      expect(response.status).to eq 200
    end

    it 'topテンプレートが表示されること' do
      get :top
      expect(response).to render_template(:top)
    end

  end

  describe '#judge' do

    it '200レスポンスが返ってきているか' do
      get :judge, params:{hand:"S1 D3 H5 C7 S9"}
      expect(response.status).to eq 200
    end

    it 'topテンプレートが表示されること' do
      get :top, params:{hand:"S1 D3 H5 C7 S9"}
      expect(response).to render_template(:top)
    end

    it '@cardsにgetパラメータを入力しているか' do
      get :judge, params:{hand:"S1 D3 H5 C7 S9"}
      expect(assigns(:cards)).to eq("S1 D3 H5 C7 S9")
    end

    it '@handsが@cardsに値を入れて作成されているか' do
      get :judge, params:{hand:"S1 D3 H5 C7 S9"}
      expect(controller.instance_variable_get("@hands").cards).to eq("S1 D3 H5 C7 S9")
    end

    #以下、mockを使って書いてみたものの、必要じゃないかもと思ったので、下書きに戻しています。
    #context 'エラーの場合' do
      #it 'judgeを実行することでエラーメッセージが作成されていること' do
        #@mock_service_1 = instance_double(PorkerJudgeService::JudgeHands)
        #allow(PorkerJudgeService::JudgeHands).to receive(:new).and_return(@mock_service_1)
        #allow(@mock_service_1).to receive(:valid)
        #allow(@mock_service_1).to receive(:error_messages).and_return(["aaaa"])
        #get :judge
        #expect(@mock_service_1.error_messages).to include "aaaa"
      #end
    #end

    #context '判定結果が出る場合' do
      #it 'judgeを実行することで判定結果が作成されていること' do
        #@mock_service_2 = instance_double(PorkerJudgeService::JudgeHands)
        #allow(PorkerJudgeService::JudgeHands).to receive(:new).and_return(@mock_service_2)
        #allow(@mock_service_2).to receive(:valid)
        #allow(@mock_service_2).to receive(:error_messages)
        #allow(@mock_service_2).to receive(:execute)
        #allow(@mock_service_2).to receive(:result).and_return("aaaa")
        #get :judge
        #expect(@mock_service_2.result).to eq("aaaa")
      #end
    #end

  end

end