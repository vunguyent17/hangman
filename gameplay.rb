# frozen_string_literal: true

require_relative 'player'

# HangMan GamePlay
class GamePlay
  def initialize(player)
    @player = player
    @guessed_letter = []
    @trials = 10
    @answer = load_dict.sample
    @is_finish = false
  end

  def load_dict
    puts 'Loading dictionary...'
    word_file = File.open('google-10000-english-no-swears.txt', 'r')
    word_list = []
    word_list.push(word_file.readline[0..-2]) until word_file.eof?
    word_file.close
    puts 'Loading complete... '
    word_list.filter! { |word| word.length >= 5 && word.length <= 12 }
  end

  def guess_a_letter
    chosen_letter = ''
    loop do
      puts "Letters you have tried: #{@guessed_letter.join(', ')}"
      chosen_letter = @player.guess_letter
      break unless @guessed_letter.include?(chosen_letter)

      puts 'You have chosen this letter. Try again'
    end
    chosen_letter
  end

  def display_word
    display_word = []
    @answer.split('').each do |letter|
      if @guessed_letter.include?(letter)
        display_word.push(letter)
      else
        display_word.push('_')
      end
    end
    display_word.join(' ')
  end

  def display_result
    if (@answer.split('') - @guessed_letter).length.zero?
      puts "Player #{@player.name} has guessed the word. "
      + "The answer is #{@answer}. #{@player.name} has #{@player.score += 1} points"
    else
      puts "You have run out of trial. The answer is #{@answer}. "
      + "#{@player.name} remains with #{@player.score} points"
    end
    @is_finish = true
  end

  def game_trial
    puts "\n=== You have #{@trials} trials left === \nCurrent word: " + display_word
    letter = guess_a_letter
    if @answer.include? letter
      puts "CORRECT. There are letter '#{letter}' in the answer"
    else
      @trials -= 1
      puts "INCORRECT. There is no '#{letter}' in the answer."
    end
    @guessed_letter.push(letter)
    puts display_word
  end

  def reset_game
    @guessed_letter = []
    @trials = 10
    @answer = ''
    @is_finish = false
  end
end
