require './lib/letter'

class NightReader

  attr_reader :reverse_dictionary, :dictionary
  def initialize(input_file, output_file)
    @output_file = output_file
    @input_file = input_file
    create_dictionary
    file_reader(input_file)
    reverse_key_vals
    rearrange_array
    letter_finder
    write_file
    puts "Created '#{output_file}' containing #{@message_length} characters"
  end

  def file_reader(input_file)
    @array = []
    file = File.open(input_file)
    file.each_line { |line|
      @array << line.chomp.split('')
    }
    @message_length = @array.join('').length / 6
    file.close
    @array
  end

  def create_dictionary
    @dictionary = Hash.new
    letters = 'abcdefghijklmnopqrstuvwxyz'.split('')
    letters.each {|letter| @dictionary[letter] = Letter.new(letter)}
    @dictionary['space'] = Letter.new('space')
  end

  def reverse_key_vals
    @reverse_dictionary = Hash.new
    @dictionary.values.each{|letter| @reverse_dictionary[letter.letter] = letter.name }
  end

  def rearrange_array
    @letters = []
    @array.each_with_index do |line, i| 
      i % 3 == 0  ? line.each_with_index do |digit, j|
        if j < line.length - 1 && j % 2 == 0
          @letters << [@array[i][j..j+1],@array[i+1][j..j+1], @array[i+2][j..j+1]]
        end 
      end : nil
    end
    #require 'pry'; binding.pry
  end

  def letter_finder
    @eng_letters = @letters.map{
      |letter|
      if @reverse_dictionary[letter] == 'space'
        ' '
      else 
        @reverse_dictionary[letter]
      end
    }.join('')
    
  end

  def write_file #takes in the array of lines, iterates over them and adds them to the file
    File.write(@output_file, @eng_letters)
  end
end

if ARGV[0] != nil && ARGV[1] != nil
  NightReader.new(ARGV[0], ARGV[1])
elsif ARGV[0] == nil
  puts 'we need a readable file'
elsif ARGV[1] == nil
  puts 'please designate a file to save to'
end