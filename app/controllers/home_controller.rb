class HomeController < ApplicationController
  include PorkerJudgeService

  def top
  end

  def judge
    @cards = params[:hand]
    @hands = JudgeHands.new(@cards)

    @hands.valid
    if @hands.error_messages.present?
      render("home/top")
    else
      @hands.execute
      render("home/top")
    end
  end

end