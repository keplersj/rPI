###
#
# This is an idea I've had since middle school.
# Nothing more, nothing less.
# And it has a shitty name.
#
###

require 'chunky_png'
require 'mathn'

include Math

RED = 'FF4136'
GREEN = '2ECC40'
BLUE = '0074D9'
ORANGE = 'FF851B'
YELLOW = 'FFDC00'
PURPLE = 'B10DC9'
WHITE = 'FFFFFF'
BLACK = '111111'
GRAY = 'AAAAAA'
SILVER = 'DDDDDD'

def find_pixel_color(integer)
  case integer
    when '1'
      RED
    when '2'
      GREEN
    when '3'
      BLUE
    when '4'
      ORANGE
    when '5'
      YELLOW
    when '6'
      PURPLE
    when '7'
      WHITE
    when '8'
      BLACK
    when '9'
      GRAY
    when '0'
      SILVER
    else
      puts "Invalid Digit: #{integer}"
      raise Exception
  end
end

def create_png
  pi_count = @pi_array.count
  png_square = (sqrt pi_count).to_i
  image = ChunkyPNG::Image.new(png_square, png_square, ChunkyPNG::Color::WHITE)

  x_axis = Array.new(png_square)
  y_axis = Array.new(png_square)

  x_offset = 0

  y_axis.each_with_index do |y_item, y_index|
    puts "Y Axis: #{y_index}"
    x_axis.each_with_index do |x_item, x_index|
      puts "X Axis: #{x_index}"
      puts "Currently Painting: [#{x_index}, #{y_index}] with Pi digit: #{@pi_array[(y_index + x_index + x_offset)]}"
      image[x_index, y_index] = ChunkyPNG::Color.from_hex find_pixel_color(@pi_array[(y_index + x_index + x_offset)])
      image.save('pi.png', :interlace => false)
    end
    x_offset = x_offset + png_square - 1
  end
end

begin

  puts 'This is rPI.'
  puts "This is an idea I've had since middle school"
  puts 'Nothing more, nothing less.'
  puts 'And it has a shitty name.'

  USE_STATIC_PI = true
  PRINT_PI = false
  @pi_array = Array.new

  case USE_STATIC_PI
    when true
      File.open 'pi.txt' do |file|
        puts "Using static pi file 'pi.txt' : #{file}."
        file.each_line do |line|
          line.to_s.each_char do |char|
            unless char == '.'
              @pi_array << char
            end
          end
        end
      end
    when false
      pi = Math::PI
      puts "Pi is: #{pi}"
      pi.to_s.each_char do |char|
        unless char == '.'
          @pi_array << char
        end
      end
    else
      puts 'Please define the USE_STATIC_PI global variable'
  end

  puts "The array containing the digits of Pi contains #{@pi_array.count} digits."
  puts "The image of pi is being created at: 'pi.png'"

  create_png

end
