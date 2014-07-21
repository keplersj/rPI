###
#
# This is an idea I've had since middle school.
# Nothing more, nothing less.
# And it has a shitty name.
#
###

require 'chunky_png'
require 'mathn'
require 'ruby-progressbar'

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

def offset(iteration, square)
  offset = 0

  case iteration
    when 0
      0
    else
      iteration.times do
        offset = offset + square - 1
      end
  end

  offset
end

def create_png
  pi_count = @pi_array.count
  png_square = (sqrt pi_count).to_i
  image = ChunkyPNG::Image.new(png_square, png_square, ChunkyPNG::Color::WHITE)

  threads = []

   png_square.times do |y|
    if MULTITHREADED_RENDERING
      threads << Thread.new do |thread|
        png_square.times do |x|
          puts "Currently Painting: [#{x}, #{y}] with Pi digit: #{@pi_array[(x + y + offset(y, png_square))]}\n" if PRINT_PROGRESS
          image[x, y] = ChunkyPNG::Color.from_hex find_pixel_color(@pi_array[(x + y + offset(y, png_square))])
          @progress_bar.increment if PROGRESS_BAR
        end
      end
    else
      png_square.times do |x|
        puts "Currently Painting: [#{x}, #{y}] with Pi digit: #{@pi_array[(x + y + offset(y, png_square))]}\n" if PRINT_PROGRESS
        image[x, y] = ChunkyPNG::Color.from_hex find_pixel_color(@pi_array[(x + y + offset(y, png_square))])
        @progress_bar.increment if PROGRESS_BAR
      end
    end
  end

  threads.each do |thr|
    thr.join
  end

  image.save('pi.png', :interlace => false)
end

begin

  puts 'This is rPI.'
  puts "This is an idea I've had since middle school"
  puts 'Nothing more, nothing less.'
  puts 'And it has a shitty name.'

  USE_STATIC_PI = true
  PRINT_PI = false
  MULTITHREADED_RENDERING = false
  PROGRESS_BAR = true
  PRINT_PROGRESS = false
  @pi_array = Array.new
  @progress_bar = nil

  case USE_STATIC_PI
    when true
      File.open 'pi.txt' do |file|
        puts "Using static pi file 'pi.txt' : #{file}."
        file.each_line do |line|
          line.gsub!(/[^0-9]/i, '')
          line.to_s.each_char do |char|
            @pi_array << char
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

  if PROGRESS_BAR
    @progress_bar = ProgressBar.create(:title => 'Painting Pi', :total => @pi_array.count)
  end

  puts "The array containing the digits of Pi contains #{@pi_array.count} digits."
  puts "The image of pi is being created at: 'pi.png'"

  create_png

end
