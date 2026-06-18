require 'yaml'

module SaveData
  def self.get_file_name
    filename = ""
    3.times {filename += File.readlines("random-name-list.txt").sample.chomp}
    filename
  end

  def self.to_save_data (secret, correct_letters, incorrect_letters, guesses)
    filename = self.get_file_name
    save_data = {
      secret: secret,
      correct_letters: correct_letters,
      incorrect_letters: incorrect_letters,
      guesses: guesses
    }
    File.write(filename, YAML.dump(save_data))
    data = YAML.load filename
    p data
  end

  def self.from_save_data(filename)
  end
end

SaveData.to_save_data("hello", [], [], 0)
