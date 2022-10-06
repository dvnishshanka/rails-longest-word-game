require 'json'
require 'open-uri'

class GamesController < ApplicationController

  def new
    @letters = []
    10.times { @letters << Array('A'..'Z').sample }
  end

  def score
    @word = params[:word].upcase.split('')
    @letters = params[:letters].split(' ')
    if check_validity_of_letters(@letters, @word)
      is_valid_word = check_validity_of_word(params[:word])
      @result = 'INVALID_WORD' unless is_valid_word
    else
      @result = 'INVALID_LETTERS'
    end
  end

  private

  def check_validity_of_letters(letters, word)
    word.each do |el|
      index = letters.find_index(el)
      return false if index.nil?

      letters.delete_at(index)
    end
  end

  def check_validity_of_word(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    dictionary_result_serialized = URI.open(url).read
    dictionary_result = JSON.parse(dictionary_result_serialized)
    dictionary_result['found']
  end

end
