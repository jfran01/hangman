class Game 
  attr_reader :secret

  def initialize
    @secret = File.readlines("google-10000-english-usa-no-swears-long.txt").sample
    @guessed = []
  end

  def new_game
    puts "Welcome to Hangman; the fun game where each wrong guess puts a (stick) man closer to his death. \nDo you need a reminder of the rules? (Y/N)"
    rules_needed = gets.chomp.upcase
    self.print_rules if rules_needed[0] == "Y"
    # call display to show length of word
    puts "Enter a letter to make your guess:"
    self.make_guess
  end

  def print_rules
    puts "Rules go here"
    puts "Press enter when you're ready to continue..."
    until gets == "\n"
      sleep(5)
    end
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
    if @guessed.include?(@current_guess)
      puts "Looks like you've already guessed that. Let's try something else:"
      self.make_guess
    end
  end
end

game = Game.new()
puts game.new_game