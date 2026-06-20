# frozen_string_literal: true

require 'yaml'

# Handles saved game files
#
# Reads and writes YAML files to saved_files/ directory
# for later access by Game class
module SaveData
  def self.generate_file_name
    filename = ''
    3.times { filename += File.readlines('random-name-list.txt').sample.chomp }
    filename
  end

  def self.to_save_data(secret, correct_letters, incorrect_letters, guesses, filename)
    save_data = {
      secret: secret,
      correct_letters: correct_letters,
      incorrect_letters: incorrect_letters,
      guesses: guesses,
      filename: filename
    }
    save_path = File.join('saved_files', filename)
    File.write(save_path, YAML.dump(save_data))
    puts "Your game was saved under: '#{filename}'"
  end

  def self.from_save_data
    filename = fetch_saved_files
    filename = File.join('saved_files', filename)
    data = YAML.load_file(filename)
    File.delete(filename)
    data
  end

  def self.fetch_saved_files
    save_files = Dir.children('saved_files')
    dir_size = save_files.size
    if dir_size == 1
      filename = save_files
    else
      puts "You have #{dir_size} games saved. Choose one from: "
      save_files.each_with_index { |file, index| puts "(#{index + 1}) #{file}" }
      filename = save_files[gets.chomp.downcase.to_i - 1]
    end
    filename
  end
end
