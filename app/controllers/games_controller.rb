require 'open-uri'

class GamesController < ApplicationController
  VOWELS = %w(A E I O U Y)

  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters
  end

  def score
    end_time   = Time.now
    start_time = params[:start_time]
    time_multiplier = (end_time - start_time.to_time) / 60
    @word      = params[:word].upcase
    word_array = @word.split('')
    @letters   = params[:letters].split('')

    valid_word = word_array.all? do |char|
      @letters.count(char) >= word_array.count(char)
    end

    if valid_word
      url = "https://wagon-dictionary.herokuapp.com/#{@word}"
      dictionary = open(url).read
      result = JSON.parse(dictionary)
      found = result["found"]
      if found
        @message = 'Congrats! You did it!'
        @score = (@word.length / time_multiplier).to_i
      else
        @message = 'Sorry, this word doesn\'t exist in our dictionary...'
      end
    else
      @message = "You cheated, you can't create this word!"
    end
    @score ||= 0
  end
end
