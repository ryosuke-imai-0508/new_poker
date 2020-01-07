module API
  module V1
    class JudgeAPI < Grape::API

      include PorkerJudgeService

      params do
        requires :cards, type: Array
      end

  #   http://localhost:3000/api/v1/cards/judge
      resource :cards do
        post '/judge' do
          cards = params[:cards]
          cards_array = []
          result_array = []
          error_array = []
          score_array = []
          score_true_or_false = []

          cards.each do |card|
            @target = JudgeHands.new(card)
            @target.valid
            if @target.error_messages.present?
              i=0
              while i < @target.error_messages.count do
                error_array.push(@target.error_messages[i])
                result_array.push(nil)
                cards_array.push(@target.hand_array.join(" "))
                score_array.push(@target.score)
                i+=1
              end
            else
              @target.execute
              result_array.push(@target.result)
              error_array.push(nil)
              cards_array.push(@target.hand_array.join(" "))
              score_array.push(@target.score)
            end

          end

          score_array.each do |score|
            if score == score_array.max
              score_true_or_false.push(true)
            else
              score_true_or_false.push(false)
            end
          end

          @api_result = {}
          @api_result[:result] = []
          @api_result[:error] = []

          cards_array.zip(error_array, result_array, score_true_or_false) do |card, error, result, score|
            unless error == nil
              @api_result[:error].push(
                  {
                      "card": card,
                      "msg": error
                  }
              )
            end

            unless result == nil
              @api_result[:result].push(
                  {
                      "card": card,
                      "hand": result,
                      "best": score
                  }
              )
            end
          end


          present @api_result


        end
      end

    end
  end
end