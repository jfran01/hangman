require 'yaml'

module SaveData
  def self.get_file_name
    filename = ""
    3.times {filename += File.readlines("random-name-list.txt").sample.chomp}
    filename
  end

  def self.to_save_data (secret, correct_letters, incorrect_letters, guesses, filename)
    save_data = {
      secret: secret,
      correct_letters: correct_letters,
      incorrect_letters: incorrect_letters,
      guesses: guesses
    }
    File.write(filename, YAML.dump(save_data))
  end

  def self.from_save_data(filename)
    data = YAML.load_file(filename)
    p data
  end
end

