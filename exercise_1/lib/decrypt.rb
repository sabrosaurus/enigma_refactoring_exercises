require_relative 'offset_calculator'
require_relative 'file_io'
require_relative 'character_map'
require_relative "rotator"

class Decrypt

  attr_reader   :rotations, :file_io, :key, :date, :calc, :characters, :rotator

  def initialize(key = ARGV[2], date = ARGV[3])
    @date       = date
    @key        = key
    @file_io    = FileIO.new
    @calc       = OffsetCalculator.new(key, date)
    # calc.rotations is an array of rotation
    # offsets, e.g. [13, 25, 36, 50]
    @rotator = Rotator.new(@calc.rotations)
    @characters = CharacterMap.new.characters
  end

  def get_rotations
    @rotations = calc.rotations.map do |rotation|
      rotation.-@
    end
  end

  def decrypt_letter_a(letter)
    a_rotated_characters = characters.rotate(rotations[0])
    Hash[characters.zip(a_rotated_characters)][letter]
  end

  def decrypt_letter_b(letter)
    b_rotated_characters = characters.rotate(rotations[1])
    Hash[characters.zip(b_rotated_characters)][letter]
  end

  def decrypt_letter_c(letter)
    c_rotated_characters = characters.rotate(rotations[2])
    Hash[characters.zip(c_rotated_characters)][letter]
  end

  def decrypt_letter_d(letter)
    d_rotated_characters = characters.rotate(rotations[3])
    Hash[characters.zip(d_rotated_characters)][letter]
  end

  def decrypt(message)
    i = 0
    decrypted_arr = []
    message_to_decrypt = message.downcase
    while i < message_to_decrypt.length
      current_character = message_to_decrypt[i]
      if i % 4 == 0 || i == 0
        puts "rotating: "
        puts rotator.rotate(current_character, 0, :backward)
        decrypted_arr << decrypt_letter_a(current_character)
      elsif i % 4 == 1 || i == 1
        rotator.rotate(current_character, 1, :backward)
        decrypted_arr << decrypt_letter_b(message_to_decrypt[i])
      elsif i % 4 == 2 || i == 2
        rotator.rotate(current_character, 2, :backward)
        decrypted_arr << decrypt_letter_c(message_to_decrypt[i])
      elsif i % 4 == 3 || i == 3
        rotator.rotate(current_character, 3, :backward)
        decrypted_arr << decrypt_letter_d(message_to_decrypt[i])
      end
      i += 1
      decrypted_input = decrypted_arr.join
    end
    decrypted_input
  end

  def print_message
    "Created '#{ARGV[1]}' with the key #{calc.key} and date #{calc.date}."
  end

end

if __FILE__ == $0

  file_io = FileIO.new
    message = file_io.message
    decryptor = Decrypt.new
    # ('12345', 280715)
    decryptor.get_rotations
    file_io.output(decryptor.decrypt(message))
    puts decryptor.print_message
end
