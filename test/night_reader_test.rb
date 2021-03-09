require "minitest/autorun"
require "minitest/pride"
require './lib/night_reader'

class NightReaderTest < Minitest::Test
  def setup
    @dictionary = Hash.new
    create_dictionary 

  end
  
end