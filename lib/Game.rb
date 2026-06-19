# frozen_string_literal: true

require_relative 'display'
require_relative 'save_manager'
require 'pry-byebug'

class Game
  include SaveData
  attr_reader :secret, :filename

  def initialize
    @display = Display.new
    @secret = File.readlines('google-10000-english-usa-no-swears-long.txt').sample.chomp
    @correct_letters = []
    @incorrect_letters = []
    @guesses = 1
  end

  def new_game
    puts 'Welcome to Hangman; the fun game where each wrong guess puts a (stick) man closer to his death.'
    puts 'Do you need a reminder of the rules? (Y/N)'
    rules_needed = gets.chomp.upcase
    print_rules if rules_needed[0] == 'Y'
    puts 'Do you wish to continue a game? (Y/N)'
    continue_game = gets.chomp.upcase
    if continue_game == 'Y'
      self.load_game
    end
    puts @display.update_correct_letters(@secret, @correct_letters)
    until @incorrect_letters.size > 6
      new_round
      if @display.correct_letters == @secret
        puts 'Congratulations! You won! You saved an innocent man from the gallows and for that your name will forever be honoured.'
        exit!
      end
    end
    puts "You lost - the word was '#{@secret}' \nCommiserations fine player, I'm sure he was guilty anyway..."
  end

  def print_rules
    puts "\nObjective: you must figure out the secret word before a fellow citizen gets put to death (the stickman is fully drawn)"
    puts 'You will be presented with a line of dashes; each dash represents a letter of the secret word (no. dashes = length of the secret word)'
    puts 'You will enter one letter of the alphabet at a time.'
    puts 'If you are correct and the letter appears in the word, all instances of the corresponding dashes will be replaced by the letter'
    puts "If you are incorrect and the letter does not appear in the word, another body part will be added to the gallows and the man will be closer to his death.\n\n"
    puts "Press enter when you're ready to continue..."
    sleep(5) until gets == "\n"
  end

  def new_round
    puts "\n--------------------------------------------------"
    puts "Round #{@guesses}"
    puts "--------------------------------------------------\n\n"
    puts "[Type 'Save' if you wish to save your progress and exit the game]"
    puts "Mistakes until death: #{6 - @incorrect_letters.size}\n\n"
    puts 'Enter a letter to make your guess:'
    make_guess
    self.save_game if @current_guess.downcase == "save"
    check_guess
    @display.update_correct_letters(@secret, @correct_letters)
    @display.draw_hangman(@incorrect_letters.size)
    @guesses += 1
  end

  def make_guess
    @current_guess = gets.chomp
    unless @current_guess[/[a-zA-Z]+/] == @current_guess
      puts "That isn't a valid letter... try again:"
      make_guess
    end
    if @current_guess.length > 1 && @current_guess.downcase != 'save' 
      @current_guess = @current_guess[0]
      puts 'Hmm, you tried to add too many letters to your guess (cheater or simple mistake?)...'
      puts "Taking just the first letter, your guess was '#{@current_guess}'."
    end
    return unless @correct_letters.include?(@current_guess) || @incorrect_letters.include?(@current_guess)

    puts "Looks like you've already guessed that. Let's try something else:"
    make_guess
  end

  def check_guess
    if @secret.split('').include?(@current_guess)
      puts "Correct! #{@current_guess} appears in the secret word."
      @correct_letters << @current_guess
    else
      puts "Oh dear... #{@current_guess} does not appear in the secret word."
      @incorrect_letters << @current_guess
      puts "Incorrect letters: #{@incorrect_letters}"
    end
  end

  def save_game
    @filename = SaveData.get_file_name unless self.filename
    SaveData.to_save_data(@secret, @correct_letters, @incorrect_letters, @guesses, @filename)
    puts "Your game was saved under: #{@filename}"
    exit!
  end

  def load_game
    data = SaveData.from_save_data
    @secret = data[:secret]
    @correct_letters = data[:correct_letters]
    @incorrect_letters = data[:incorrect_letters]
    @guesses = data[:guesses]
    @filename = data[:filename]
    @display.update_correct_letters(@secret, @correct_letters)
    @display.draw_hangman(@incorrect_letters.size)
    puts "Incorrect letters: #{@incorrect_letters}"
  end
end

game = Game.new
game.new_game