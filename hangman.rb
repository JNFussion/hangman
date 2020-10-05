class Hangman
    attr_reader :guess_word


    def initialize
        @guess_word  = generate_guess_word
        @incorrect_letters = []
        @correct_letters = []
    end

    def display_menu
        puts 'MAIN MENU:'
        puts '0. Exit game'
        puts '1. Play game'
        puts '2. Save game'
        puts '3. Load game'
        loop do
            puts 'Select option (number):'
            option = gets.chomp

            case option
                when '0'
                    break
                when '1'
                    self.play_game
                when '2' 
                    self.save_game
                when '3'
                    self.load_game
                else
                    puts 'Incorrect option, try again.'
                    puts
                    
            end
        end
    end



    private

    #Read all the words in the file, then split the string in a array and delete words tha are smaller than 5 or longer than 12. Finally take 1 word from the array.

    def generate_guess_word
        dic  = File.read 'dictionary.txt'
        dic = dic.split(/\n/).map{ |value| value.chomp }.delete_if{ |value| value.length < 5 || value.length > 12}
        dic.sample
    end

end

game  = Hangman.new

game.display_menu
