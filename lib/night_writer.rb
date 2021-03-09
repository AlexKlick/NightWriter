require 'matrix'
require './lib/letter'

class NightWriter

  attr_reader :message, :dictionary
  def initialize(input_file, output_file)
    @output_file = output_file
    @input_file = input_file
    @dictionary = Hash.new
    create_dictionary #builds the hash of letter objects
    file_reader(@input_file) #method to parse the file, sending back @array (nested array of letters) and @message_length (int)
    create_braile_array
    write_file
    #require 'pry'; binding.pry
    puts "Created '#{output_file}' containing #{@message_length} characters"
  end

  def create_dictionary
    letters = 'abcdefghijklmnopqrstuvwxyz'.split('')
    letters.each {|letter| @dictionary[letter] = Letter.new(letter)}
    @dictionary['space'] = Letter.new('space')
  end

  def file_reader(input_file)
    @array = []
    file = File.open(input_file)
    file.each_line { |line|
      @array << line.chomp.split('')
    }
    @message_length = @array.join('').length
    file.close
    return @array
  end

  def create_braile_array
    new_array = Array.new(3,'') 
    @braile_array = Array.new(@array.length,'')
    @array.each_with_index do |line, i| #each element of @array is a line, each line has at least 1 element. 
      line.each do |e|                  #performs the seperation of braile_letters and puts them in braile_array, 
        if e == ' '                     #which has each line of the final output as elements in nested array. 
          e = 'space'
        end
        new_array[0] = new_array[0] + dictionary[e].letter[0].join('')
        new_array[1] = new_array[1] + dictionary[e].letter[1].join('')
        new_array[2] = new_array[2] + dictionary[e].letter[2].join('')
      end
      @braile_array[i] = new_array  #each instance of new array at this point is a line from the input, and will have 3 elements
      new_array = Array.new(3,'')  #resets the new_array 
    end
    return @braile_array
  end

  def write_file #takes in the array of lines, iterates over them and adds them to the file
    @braile_array.each{|line| 
      line.each{ |braile_line|
        File.write(@output_file, braile_line, mode: "a")
        File.write(@output_file, "\n", mode: "a")
      }}
  end
end
if ARGV[0] != nil
  NightWriter.new(ARGV[0], ARGV[1])
end
