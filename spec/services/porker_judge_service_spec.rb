require 'rails_helper'

include PorkerJudgeService

RSpec.describe PorkerJudgeService do

  describe 'エラーに関して' do

    context 'カード枚数のエラー' do

      context 'カード枚数が５枚未満の時'do
        before do
          @hands = JudgeHands::JudgeHands.new("S1")
        end
        it 'カード枚数に関するエラーが出ること' do
          @hands.valid
          expect(@hands.error_messages).to include "半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせで５枚のカードを指定してください。(例)S1 H3 D9 C13 S11"
        end
        it '@scoreが0になっていること' do
          @hands.valid
          expect(@hands.score).to eq 0
        end
      end

      context 'カード枚数が５枚より多い時' do
        before do
          @hands = JudgeHands::JudgeHands.new("S1 D3 H5 C7 S9 D11")
        end
        it 'カード枚数に関するエラーが出ること' do
          @hands.valid
          expect(@hands.error_messages).to include "半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせで５枚のカードを指定してください。(例)S1 H3 D9 C13 S11"
        end
        it '@scoreが0になっていること' do
          @hands.valid
          expect(@hands.score).to eq 0
        end
      end

      context 'カードがない時' do
        before do
          @hands = JudgeHands::JudgeHands.new(" ")
        end
        it 'カード枚数に関するエラーが出ること' do
          @hands.valid
          expect(@hands.error_messages).to include "半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせで５枚のカードを指定してください。(例)S1 H3 D9 C13 S11"
        end
        it '@scoreが0になっていること' do
          @hands.valid
          expect(@hands.score).to eq 0
        end
      end

    end

    context '不適切なカードのエラー' do

      context 'カードがスペース以外で区切られている時' do
        before do
          @hands = JudgeHands::JudgeHands.new("S1/D3/H5/C7/S9")
        end
        it '不適切な表記を指摘するエラーが出ること' do
          @hands.valid
          expect(@hands.error_messages).to include "半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせで５枚のカードを指定してください。(例)S1 H3 D9 C13 S11"
        end
        it '@scoreが0になっていること' do
          @hands.valid
          expect(@hands.score).to eq 0
        end
      end

      context '余分な文字が含まれている時' do
        before do
          @hands = JudgeHands::JudgeHands.new("S1 D3 H5 C7t S9")
        end
        it '不適切なカードを指摘するエラーが出ること' do
          @hands.valid
          expect(@hands.error_messages).to include "4番目のカード指定文字が不正です。(C7t)"
        end
        it '@scoreが0になっていること' do
          @hands.valid
          expect(@hands.score).to eq 0
        end
      end

      context 'スートが不正の時' do
        before do
          @hands = JudgeHands::JudgeHands.new("G1 D3 H5 C7 S9")
        end
        it '不適切なカードを指摘するエラーが出ること' do
          @hands.valid
          expect(@hands.error_messages).to include "1番目のカード指定文字が不正です。(G1)"
        end
        it '@scoreが0になっていること' do
          @hands.valid
          expect(@hands.score).to eq 0
        end
      end

      context '数字が不正の時' do
        before do
          @hands = JudgeHands::JudgeHands.new("S1 D3 H15 C7 S9")
        end
        it '不適切なカードを指摘するエラーが出ること' do
          @hands.valid
          expect(@hands.error_messages).to include "5番目のカード指定文字が不正です。(H15)"
        end
        it '@scoreが0になっていること' do
          @hands.valid
          expect(@hands.score).to eq 0
        end
      end

      context 'カードが重複している時' do
        before do
          @hands = JudgeHands::JudgeHands.new("S1 S1 H5 C7 S9")
        end
        it 'カードの重複を指摘するエラーが出ること' do
          @hands.valid
          expect(@hands.error_messages).to include "カードが重複しています。"
        end
        it '@scoreが0になっていること' do
          @hands.valid
          expect(@hands.score).to eq 0
        end
      end

    end

  end

  describe '判定結果に関して' do

    context 'スートが同じで数字が連続する５枚のカードの場合' do
      before do
        @hands = JudgeHands::JudgeHands.new("S1 S2 S3 S4 S5")
      end
      it '「ストレートフラッシュ」と出ること' do
        @hands.valid
        @hands.execute
        expect(@hands.result).to eq "ストレートフラッシュ"
      end
      it '@scoreが9になっていること' do
        @hands.valid
        @hands.execute
        expect(@hands.score).to eq 9
      end
    end

    context '５枚のカードの内、同じ数字のカードが４枚含まれる場合' do
      before do
        @hands = JudgeHands::JudgeHands.new("S1 D1 H1 C1 S3")
      end
      it '「フォーカード」と出ること' do
        @hands.valid
        @hands.execute
        expect(@hands.result).to eq "フォーカード"
      end
      it '@scoreが8になっていること' do
        @hands.valid
        @hands.execute
        expect(@hands.score).to eq 8
      end
    end

    context '同じ数字のカードが３枚と別の同じ数字のカードが２枚の場合' do
      before do
        @hands = JudgeHands::JudgeHands.new("S1 D1 H1 C3 S3")
      end
      it '「フルハウス」と出ること' do
        @hands.valid
        @hands.execute
        expect(@hands.result).to eq "フルハウス"
      end
      it '@scoreが7になっていること' do
        @hands.valid
        @hands.execute
        expect(@hands.score).to eq 7
      end
    end

    context '５枚のカードのスートが全て同じ場合' do
      before do
        @hands = JudgeHands::JudgeHands.new("S1 S3 S5 S7 S9")
      end
      it '「フラッシュ」と出ること' do
        @hands.valid
        @hands.execute
        expect(@hands.result).to eq "フラッシュ"
      end
      it '@scoreが6になっていること' do
        @hands.valid
        @hands.execute
        expect(@hands.score).to eq 6
      end
    end

    context '５枚のカードの数字が全て連続の場合' do
      before do
        @hands = JudgeHands::JudgeHands.new("S1 D2 H3 C4 S5")
      end
      it '「ストレート」と出ること' do
        @hands.valid
        @hands.execute
        expect(@hands.result).to eq "ストレート"
      end
      it '@scoreが5になっていること' do
        @hands.valid
        @hands.execute
        expect(@hands.score).to eq 5
      end
    end

    context '５枚のカードの内、同じ数字のカードが３枚含まれる場合' do
      before do
        @hands = JudgeHands::JudgeHands.new("S1 D1 H1 C2 S3")
      end
      it '「スリーカード」と出ること' do
        @hands.valid
        @hands.execute
        expect(@hands.result).to eq "スリーカード"
      end
      it '@scoreが4になっていること' do
        @hands.valid
        @hands.execute
        expect(@hands.score).to eq 4
      end
    end

    context '５枚のカードの内、同じ数字の２枚のカードの組みが２つの場合' do
      before do
        @hands = JudgeHands::JudgeHands.new("S1 D1 H2 C2 S3")
      end
      it '「ツーペア」と出ること' do
        @hands.valid
        @hands.execute
        expect(@hands.result).to eq "ツーペア"
      end
      it '@scoreが3になっていること' do
        @hands.valid
        @hands.execute
        expect(@hands.score).to eq 3
      end
    end

    context '５枚のカードの内、同じ数字の２枚のカードの組みが１つの場合' do
      before do
        @hands = JudgeHands::JudgeHands.new("S1 D1 H2 C3 S4")
      end
      it '「ワンペア」と出ること' do
        @hands.valid
        @hands.execute
        expect(@hands.result).to eq "ワンペア"
      end
      it '@scoreが2になっていること' do
        @hands.valid
        @hands.execute
        expect(@hands.score).to eq 2
      end
    end

    context 'その他の場合' do
      before do
        @hands = JudgeHands::JudgeHands.new("S1 D3 H5 C7 S9")
      end
      it '「ハイカード」と出ること' do
        @hands.valid
        @hands.execute
        expect(@hands.result).to eq "ハイカード"
      end
      it '@scoreが1になっていること' do
        @hands.valid
        @hands.execute
        expect(@hands.score).to eq 1
      end
    end


  end

end

