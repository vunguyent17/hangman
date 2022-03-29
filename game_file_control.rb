# frozen_string_literal: true

require_relative 'gameplay'
require_relative 'basic_serialization'
require_relative 'player'

# File control for Hangman game
class GameFileControl < GamePlay
  include BasicSerializable
  def initialize(player)
    super(player)
    @id = ''
  end

  def save_gameplay
    data_list = load_list_data
    reset_game if @is_finish
    @id = create_id
    new_save = serialize
    if data_list != [] && (data_list.map { |data| data['id'] }).include?(@id)
      overwrite_data(data_list, new_save)
    else
      add_data(new_save)
    end
  end

  def load_list_data
    read_file = File.open('save_game.txt', 'r')
    data_list = read_file.readlines
    read_file.close
    data_list.map { |data| @@serializer.parse(data) }
  end

  def overwrite_data(data_list, new_data)
    save_file = File.open('save_game.txt', 'w')
    data_list.each do |data|
      if data['id'] == @id
        save_file.puts(new_data)
      else
        save_file.puts(@@serializer.dump(data))
      end
    end
    save_file.close
    puts 'Data overwritten successfully'
  end

  def add_data(new_data)
    save_file = File.open('save_game.txt', 'a')
    save_file.puts(new_data)
    save_file.close
    puts 'Data added successfully'
  end

  def create_id
    print 'Type name of this saved data: '
    gets.chomp
  end

  def load_gameplay(id)
    load_file = File.open('save_game.txt', 'r')
    until load_file.eof?
      obj = @@serializer.parse(load_file.readline)
      next unless obj['id'] == id

      unserialize(obj)
      load_file.close
      puts 'Data loaded successfully'
      return
    end
    puts 'Error'
  end

  def serialize
    obj = {}
    instance_variables.map do |var|
      obj[var.to_s.delete('@')] = instance_variable_get(var)
    end
    obj['player'] = @player.to_hash

    @@serializer.dump obj
  end

  def unserialize(obj)
    obj.each_key do |key|
      next if key == 'id'

      if key == 'player'
        @player = Player.new(obj['player']['name'], obj['player']['score'])
      else
        instance_variable_set("@#{key}", obj[key])
      end
    end
  end
end
