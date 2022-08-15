require 'pry'
require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    arr = ('a'..'z').to_a
    @letters = []
    10.times { @letters << arr.sample }
  end

  def score
    @word = params[:word].downcase
    @letter_list = params[:letter_list].split(' ')
    @score = 0

    if real_word?(@word) && in_list?(@word, @letter_list)
      @message = "#{@word} is valid"
      @score = calculate_score(@word)
    elsif !real_word?(@word)
      @message = "#{@word} is not in the dictionary"
    else
      @message = "#{@word} is not in the list (#{@letters})"
    end
  end

  private

  def calculate_score(word)
    # returns the score, taking into account length only
    word.length * 5
  end

  def real_word?(word)
    # returns true/false if a word is real
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    user_serialized = URI.parse(url).open.read
    user = JSON.parse(user_serialized)
    user['found']
  end

  def in_list?(word, list)
    # returns true/false if a word is in the letter_list
    word.split('').each do |letter|
      return false unless letter in list

      list[list.index(letter)] = ''
    end
  end
end
