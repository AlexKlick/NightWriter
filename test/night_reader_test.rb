require "minitest/autorun"
require "minitest/pride"
require './lib/night_reader'

class NightWriterTest < Minitest::Test
  def setup
    @nightWriter = NightReader.new('write_test_reverse.txt','test.txt')
    @dictionary = Hash.new
  end

  def test_create_dictionary
    letters = 'abcdefghijklmnopqrstuvwxyz'.split('')
    letters.each {|letter| @nightWriter.dictionary[letter] = Letter.new(letter)}
    assert_equal @nightWriter.reverse_dictionary[[['0', '.'], ['.','.'], ['.','.']]].letter, Letter.new('a').name
  end

  # def test_file_reader
  #   assert_equal @nightWriter.file_reader('write_test.txt'), [["h", "e", "l", "l", "o", " ", "w", "o", "r", "l", "d"], ["g", "o", "o", "d", "b", "y", "e", " ", "w", "o", "r", "l", "d"]]
  #   assert_equal @nightWriter.file_reader('write_test.txt').flatten.length, 24
  # end

  # def test_create_braile_array
  #   @nightWriter.create_braile_array
  #   assert_equal @nightWriter.braile_array,[["0.0.0.0.0....00.0.0.00", "00.00.0..0..00.0000..0", "....0.0.0....00.0.0..."],
  #   ["000.0.000.000....00.0.0.00", "00.0.0.0...0.0..00.0000..0", "..0.0.....00.....00.0.0..."]]
  # end
  
  # def test_write_file
  #   assert_equal File.read("test.txt").split[0], "0.0.0.0.0....00.0.0.00"
  #   File.write("test.txt", nil)
  # end
end
