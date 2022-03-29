# frozen_string_literal: true

# Player who play Hangman Game
class Player
  attr_accessor :name, :score

  def initialize(*args)
    case args.size
    when 0
      print 'Type your name: '
      @name = gets.chomp
      @score = 0
    when 2
      @name = args[0]
      @score = args[1]
    end
  end

  def guess_letter
    print 'Guess a new letter: '
    gets.chomp.downcase
  end

  def to_hash
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete('@')] = instance_variable_get(var) }
    hash
  end
end
