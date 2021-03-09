require './lib/letter'

class NightWriter

  attr_reader :dictionary, :braile_array
  def initialize(input_file, output_file)
    @output_file = output_file
    @dictionary = Hash.new
    require 'pry'; binding.pry
    create_dictionary #builds the hash of letter objects
    file_reader(input_file) #method to parse the file, sending back @array (nested array of letters) and @message_length (int)
    create_braile_array
    write_file
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
    @array
  end

  def create_braile_array
    new_array = Array.new(3,'') 
    @braile_array = Array.new(@array.length,'')
    @array.each_with_index do |line, i| #each element of @array is a line, each line has at least 1 element. 
      line.each do |elem|                  #performs the seperation of braille_letters and puts them in braille_array, 
        if elem == ' '                     #which has each line of the final output as elements in nested array. 
          elem = 'space'
        end
        new_array[0] += dictionary[elem].letter[0].join('')
        new_array[1] += dictionary[elem].letter[1].join('')
        new_array[2] += dictionary[elem].letter[2].join('')
      end
      @braile_array[i] = new_array  #each instance of new array at this point is a line from the input, and will have 3 elements
      new_array = Array.new(3,'')  #resets the new_array 
    end
    @eigthy_char_limit_array = Array.new(3,'')
    @braile_array.each_with_index{
      |elem, i| 
      @eigthy_char_limit_array[0] += elem[0]
      @eigthy_char_limit_array[1] += elem[1]
      @eigthy_char_limit_array[2] += elem[2]
        if i != @braile_array.length - 1
          @eigthy_char_limit_array[0] += '..'
          @eigthy_char_limit_array[1] += '..'
          @eigthy_char_limit_array[2] += '..'
        end
    }
    @braile_array
    if @eigthy_char_limit_array[0].length / 80 > 0
      @braile_array = Array.new(@eigthy_char_limit_array[0].length / 20, Array.new(3,''))
      for i in 0.. @eigthy_char_limit_array[0].length / 80 do
        @braile_array[i][0] = @eigthy_char_limit_array[0][(i * 80)..(79 * (i + 1))]
        @braile_array[i][1] = @eigthy_char_limit_array[1][(i * 80)..(79 * (i + 1))]
        @braile_array[i][2] = @eigthy_char_limit_array[2][(i * 80)..(79 * (i + 1))]
      end
    end
  end

  def write_file #takes in the array of lines, iterates over them and adds them to the file
    @braile_array.each{|line| 
      line.each{ |braile_line|
        File.write(@output_file, braile_line, mode: "a")
        File.write(@output_file, "\n", mode: "a")
      }}
  end
end
#check to see if file to read argument has been given
if ARGV[0] != nil && ARGV[1] != nil
  NightWriter.new(ARGV[0], ARGV[1])
elsif ARGV[0] == nil
  puts 'we need a readable file'
elsif ARGV[1] == nil
  puts 'please designate a file to save to'
end
