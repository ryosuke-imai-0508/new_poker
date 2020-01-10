module API
  module V1
    class JudgeAPI < Grape::API

      include PorkerJudgeService

      params do
        requires :cards, type: Array
      end

      helpers do
        def judge_best(array)
          score_true_or_false = []
          array.each do |score|
            if score == array.max
              score_true_or_false.push(true)
            else
              score_true_or_false.push(false)
            end
          end
          score_true_or_false
        end
      end

  #   http://localhost:3000/api/v1/cards/judge
      resource :cards do
        post '/judge' do
          cards = params[:cards]
          cards_array = []
          result_array = []
          error_array = []
          score_array = []

          cards.each do |card|
            target = JudgeHands.new(card)
            target.valid
            if target.error_messages.present?
              error_array.push(target.error_messages.join(" / "))
              result_array.push(nil)
              cards_array.push(target.hand_array.join(" "))
              score_array.push(target.score)
            else
              target.execute
              result_array.push(target.result)
              error_array.push(nil)
              cards_array.push(target.hand_array.join(" "))
              score_array.push(target.score)
            end

          end

          score_true_or_false = judge_best(score_array)

          # score_true_or_false = []
          # score_array.each do |score|
          #   if score == score_array.max
          #     score_true_or_false.push(true)
          #   else
          #     score_true_or_false.push(false)
          #   end
          # end

          api_result = {}
          api_result[:result] = []
          api_result[:error] = []

          cards_array.zip(error_array, result_array, score_true_or_false) do |card, error, result, score|
            if result.present?
              api_result[:result].push(
                  {
                      "card": card,
                      "hand": result,
                      "best": score
                  }
              )
            end

            if error.present?
              api_result[:error].push(
                  {
                      "card": card,
                      "msg": error
                  }
              )
            end

          end

          present api_result


        end
      end

    end
  end
end