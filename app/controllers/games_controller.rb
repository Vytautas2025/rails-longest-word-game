require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ("a".."z").to_a.sample }
  end

  def score
    @attempt = params[:letter].upcase
    @grid = params[:letters].upcase.chars

    @result =
      if !included_in_grid?(@attempt, @grid)
        "The word can't be built out of the original grid."
      elsif !english_word?(@attempt)
        "The word is not a valid English word."
      else
        "Good job! '#{@attempt}' is valid!"
      end
  end

  private

  def included_in_grid?(attempt, grid)
    attempt.chars.all? { |char| attempt.count(char) <= grid.count(char) }
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word.downcase}"
    response = URI.open(url).read
    json = JSON.parse(response)
    json["found"]

  end
end
