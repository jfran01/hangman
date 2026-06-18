# frozen_string_literal: true

class Display
  attr_reader :correct_letters

  def initialize
    @correct_letters = ''
    @hangman_drawer = ["   +-----+\n   |/\n   |\n   |\n   |\n   |\n   |\n -------- \n\n",
                       "   +-----+\n   |/    |\n   |     O\n   |\n   |\n   |\n   |\n -------- \n\n",
                       "   +-----+\n   |/    |\n   |     O\n   |     |\n   |\n   |\n   |\n -------- \n\n",
                       "   +-----+\n   |/    |\n   |     O\n   |    /|\n   |\n   |\n   |\n -------- \n\n",
                       "   +-----+\n   |/    |\n   |     O\n   |    /|\\\n   |\n   |\n   |\n -------- \n\n",
                       "   +-----+\n   |/    |\n   |     O\n   |    /|\\\n   |    /\n   |\n   |\n -------- \n\n",
                       "   +-----+\n   |/    |\n   |     O\n   |    /|\\\n   |    / \\\n   |\n   |\n -------- \n\n"]
  end

  def update_correct_letters(secret, correct_letters)
    @correct_letters = ''
    secret.split('').each do |letter|
      @correct_letters += if correct_letters.include?(letter)
                            letter
                          else
                            '-'
                          end
    end
    puts "\nword: #{@correct_letters}\n"
  end

  def draw_hangman(num)
    puts @hangman_drawer[num - 1] unless num.zero?
  end
end
