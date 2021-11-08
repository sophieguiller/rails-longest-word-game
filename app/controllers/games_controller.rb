require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word]
    if exclude?(@word, params[:letters])
      @result = "Sorry but #{@word} can't be build out of #{params[:letters]}"
    elsif english_word?(@word) == false
      @result = "Sorry but #{@word} does not seem to be a valid english word..."
    else
      @result = "Congrats!"
      @score = @word.length
    end
  end

  def english_word?(attempt)
    file_json = URI.open("https://wagon-dictionary.herokuapp.com/#{attempt}").read
    words = JSON.parse(file_json)
    words["found"]
  end

  def exclude?(attempt, grid)
    attempt.chars.all? { |letter| attempt.count(letter) <= grid.count(letter) }
  end
end
