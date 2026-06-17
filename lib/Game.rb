class Game 
  attr_reader :secret

  def initialize
    @secret = File.readlines("google-10000-english-usa-no-swears-long.txt").sample
  end

  def new_game
    puts "Welcome to Hangman; the fun game where each wrong guess puts a (stick) man closer to his death. \nDo you need a reminder of the rules? (Y/N)"
    rules_needed = gets.chomp.upcase
    self.print_rules if rules_needed[0] == "Y"
    puts "continuing"
  end

  def print_rules
    puts "Rules go here"
    puts "Press enter when you're ready to continue..."
    until gets == "\n"
      sleep(5)
    end
  end
end

game = Game.new()
puts game.new_game