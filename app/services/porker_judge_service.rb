
module PorkerJudgeService

  class JudgeHands

    attr_accessor :hand_array, :cards, :hands, :result, :error_messages, :score

    def initialize(card)
      @cards = card
    end

#   エラーを定義
    def valid
#   エラーメッセージを貯めていく配列を定義
      @error_messages = []
#   入力されたものを配列に
      @hand_array = @cards.split.sort_by {|k| k[/\d+/].to_i}

#   配列の要素数が５個じゃない場合をはじく
      if (@hand_array.size.to_i != 5)
        error_message1 = "半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせで５枚のカードを指定してください。(例)S1 H3 D9 C13 S11"
        @error_messages.push(error_message1)
      else

#   アルファベットだけ、数字だけ抽出した配列をそれぞれ作る
        @suits = []
        @numbers = []
        @hand_array.each do |hand|
          @suits.push(hand.slice(0).to_s)
          @numbers.push(hand.gsub(/[^\d]/, ""))
        end

#   取り出したスートと数字を再度並べてみる:もともとのものと比較するため
        hand_check = []
        n=0
        while n<=@suits.count do
          hand_check.push("#{@suits[n]}"+"#{@numbers[n]}")
          n+=1
        end

#   入力されたものと並べ直したものを比較して違う箇所を抜き出す
        @hand_array.zip(hand_check).each_with_index do |(x,y),i|
          if (x!=y)
            error_message2 = "#{i+1}番目のカード指定文字が不正です。(#{@hand_array[i]})"
            @error_messages.push(error_message2)
          end
        end

#   それぞれのカードの中に不適切なスートがないか確認
        @suits.each_with_index do |x,i|
          unless x=="S" || x=="D" || x=="H" || x=="C"
            error_message3 = "#{i+1}番目のカード指定文字が不正です。(#{@hand_array[i]})"
            @error_messages.push(error_message3)
          end
        end

#   それぞれのカードの中に不適切な数字がないか確認
        @numbers.each_with_index do |n,i|
          unless (n.to_i>=1) && (n.to_i<=13)
            error_message4 = "#{i+1}番目のカード指定文字が不正です。(#{@hand_array[i]})"
            @error_messages.push(error_message4)
          end
        end

#   重複がないか
        if hand_check.uniq.count != hand_check.count && @error_messages.blank?
          error_message5 = "カードが重複しています。"
          @error_messages.push(error_message5)
        end

      end
      #if (@hand_array.size.to_i != 5)のend

      @score = 0

    end
    #def validのend
#   エラーここまで

#   役の判定を定義
    def execute

      numbers_gaps = []
      i = 0
      while i<=3 do
        numbers_gap_i = (@numbers[i+1].to_i) - (@numbers[i].to_i)
        numbers_gaps.push(numbers_gap_i)
        i+=1
      end

#   数字の組を表すハッシュを作る（→.valuesで数だけを取り出した配列を作って使う）
      numbers_count = @numbers.group_by(&:itself).map{ |key, value| [key, value.count] }.to_h

#   ストレートフラッシュの判定
      if((@suits.uniq.count == 1) && ((numbers_gaps.uniq == [1]) ||(numbers_gaps.sort == [1,1,1,9])))
        @result = "ストレートフラッシュ"
        @score = 9
#   フォーカードの判定
      elsif((numbers_count.values == [1,4]) || (numbers_count.values == [4,1]))
        @result = "フォーカード"
        @score = 8
#   フルハウスの判定
      elsif((numbers_count.values == [2,3]) || (numbers_count.values == [3,2]))
        @result = "フルハウス"
        @score = 7
#   フラッシュの判定
      elsif(@suits.uniq.count == 1)
        @result = "フラッシュ"
        @score = 6
#   ストレートの判定
      elsif((numbers_gaps.uniq == [1]) || (numbers_gaps.sort == [1,1,1,9]))
        @result = "ストレート"
        @score = 5
#   スリーカードの判定
        elsif((numbers_count.values == [1,1,3]) || (numbers_count.values == [1,3,1]) || (numbers_count.values == [1,1,3]))
        @result = "スリーカード"
        @score = 4
#   ツーペアの判定
      elsif(@numbers.uniq.count == 3)
        @result = "ツーペア"
        @score = 3
#   ワンペアの判定
      elsif(@numbers.uniq.count == 4)
        @result = "ワンペア"
        @score = 2
#   その他
      else
        @result = "ハイカード"
        @score = 1
      end
      #役判定のifのend
    end
    #def executeのend
  end
  #classのend

end
#moduleのend