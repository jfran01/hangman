require_relative "Display"
require "pry-byebug"

class Game 
  attr_reader :secret

  def initialize
    @display = Display.new
    @secret = File.readlines("google-10000-english-usa-no-swears-long.txt").sample.chomp
    @guessed = []
    @correct_letters = []
    @incorrect_letters = []
    @guesses = 1
  end

  def new_game
    puts "Welcome to Hangman; the fun game where each wrong guess puts a (stick) man closer to his death. \nDo you need a reminder of the rules? (Y/N)"
    rules_needed = gets.chomp.upcase
    self.print_rules if rules_needed[0] == "Y"
    until @incorrect_letters.size > 6 
        self.new_round
        if @display.correct_letters == @secret
          puts "Congratulations! You won! You saved an innocent man from the gallows and for that your name will forever be honoured."
          exit!
        end
    end
    puts "You lost - the word was '#{@secret}' \nCommiserations fine player, I'm sure he was guilty anyway..."
  end

  def print_rules
    puts "Rules go here"
    puts "Press enter when you're ready to continue..."
    until gets == "\n"
      sleep(5)
    end
  end

  def new_round
    puts "\n--------------------------------------------------"
    puts "Round #{@guesses}"
    puts "--------------------------------------------------\n\n"
    puts "Mistakes until death: #{6 - @incorrect_letters.size}\n\n"
    puts "Enter a letter to make your guess:"
    self.make_guess
    self.check_guess
    @display.update_correct_letters(@secret, @correct_letters)
    @display.draw_hangman(@incorrect_letters.size)
    @guesses += 1
  end

  def make_guess
    @current_guess = gets.chomp
    unless @current_guess[/[a-zA-Z]+/] == @current_guess
      puts "That isn't a valid letter... try again:"
      self.make_guess
    end
    if @current_guess.length > 1
      @current_guess = @current_guess[0]
      puts "Hmm, you tried to add too many letters to your guess (cheater or simple mistake?)... \nTaking just the first letter, your guess was '#{@current_guess}'."
    end
    if @correct_letters.include?(@current_guess) || @incorrect_letters.include?(@current_guess)
      puts "Looks like you've already guessed that. Let's try something else:"
      self.make_guess
    end
  end

  def check_guess
    if @secret.split("").include?(@current_guess)
      puts "Correct! #{@current_guess} appears in the secret word."
      @correct_letters << @current_guess
    else 
      puts "Oh dear... #{@current_guess} does not appear in the secret word."
      @incorrect_letters << @current_guess
    end
  end
end

game = Game.new()
game.new_game