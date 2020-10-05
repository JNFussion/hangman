require 'yaml'

# Represent hangman game. You have to guess a word. It's read randomly from a text file.
# It's have 3 option play the game, save the game or load a game.

class Hangman
  attr_accessor :win, :game_over, :life, :guess_word, :display_guess_word, :incorrect_letters

  def initialize
    @win = false
    @game_over = false
    @life = 8
    @guess_word = Hangman.generate_guess_word
    @display_guess_word = '_ ' * @guess_word.length
    @incorrect_letters = []
    @guess = ''
  end

  def display_menu
    loop do
      puts '*' * 50
      puts 'MAIN MENU:'
      puts '0. Exit game'
      puts '1. Play game'
      puts '2. Save game'
      puts '3. Load game'
      puts 'Select option (number):'
      option = gets.chomp

      case option
      when '0'
        break
      when '1'
        puts '*' * 50
        play_game
      when '2'
        save_game
      when '3'
        load_game
      else
        puts 'Incorrect option, try again.'
        puts
        sleep(1)

      end
    end
  end

  # Read all the words in the file, then split the string in a array
  # and delete words tha are smaller than 5 or longer than 12.
  # Finally take 1 word from the array.

  def self.generate_guess_word
    dic = File.read 'dictionary.txt'
    dic = dic.split(/\n/).map(&:chomp).delete_if { |value| value.length < 5 || value.length > 12 }
    dic.sample.downcase
  end

  private

  def load_game
    game_file = File.new('save_games/hangman_save.yaml', 'r')
    yaml = YAML.load(game_file.read)
    self.win = yaml.win
    self.game_over = yaml.game_over
    self.life = yaml.life
    self.guess_word = yaml.guess_word
    self.display_guess_word = yaml.display_guess_word
    self.incorrect_letters = yaml.incorrect_letters
  end

  def save_game
    Dir.mkdir('save_games') unless Dir.exist? 'save_games'
    game_file = File.new('save_games/hangman_save.yaml', 'w')
    game_file.write(YAML.dump(self))
  end

  def play_game
    star_game if @game_over

    until @life.zero?
      display_game
      if @guess == '1'
        @game_over = true
        @win = true
        puts 'YOU WIN!'
        break
      end
      return if @guess == 'exit'
    end

    if life.zero?
      puts @guess_word
      puts 'YOU LOSE!'
    end
  end

  def display_game
    puts "Attemps: #{@life}"
    puts 'Word: ' + @display_guess_word
    @guess = check_guess(get_input)
    print 'Misses: '
    print @incorrect_letters
    puts
    puts '*' * 50
  end

  def check_guess(str)
    return str if str == 'exit'
    return '1' if str == @guess_word
    return if @incorrect_letters.include? str

    if @guess_word.include?(str)
      @guess_word.split('').each_with_index do |value, index|
        @display_guess_word[index * 2] = str if value == str
      end
    else
      @life -= 1
      @incorrect_letters << str
    end

    return '1' if @display_guess_word.gsub(/\s+/, '') == @guess_word
  end

  def get_input
    guess = ''
    loop do
      puts 'Guess:'
      guess = gets.chomp
      break if guess == 'exit'
      break if guess.length == 1 && guess.match(/\w/) || guess.length == @guess_word.length

      puts 'Incorret input, introduce a letter o try to guess the word.'
    end
    guess.downcase
  end

  def star_game
    @win = false
    @game_over = false
    @life = 8
    @guess_word = Hangman.generate_guess_word
    @display_guess_word = '_ ' * @guess_word.length
    @incorrect_letters = []
    @correct_letters = []
  end
end

game = Hangman.new
game.display_menu
