# frozen_string_literal: true

require_relative 'gameplay'
require_relative 'game_file_control'
require_relative 'player'

# HangMan = GamePlay + file control
class HangMan < GameFileControl
  def initialize
    print "Type saved gameplay name -> hit Enter to load gameplay data\n" \
          ' or leave it blank -> hit Enter create new game: '
    id = gets.chomp
    if id == ''
      super(Player.new)
    else
      super(nil)
      load_gameplay(id)
    end
    run_multiple_games
  end

  def run_multiple_games
    loop do
      run_game
      print 'Do you want to continue? (y/n): '
      choice = gets.chomp
      break if choice == 'n'

      @answer = load_dict.sample
    end
    print 'Thank you for playing :)'
  end

  def run_game
    puts "Guess this word: #{display_word}"
    while @trials.positive?
      game_trial
      break if (@answer.split('') - @guessed_letter).length.zero?

      show_options
    end
    display_result
    show_options
  end

  def show_options
    print 'Hit "s" to save the game and continue, Enter to continue without saving: '
    input = gets.chomp
    save_gameplay if input == 's'
  end
end
