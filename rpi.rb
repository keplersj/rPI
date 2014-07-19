###
#
# This is an idea I've had since middle school.
# Nothing more, nothing less.
# And it has a shitty name.
#
###

begin

  puts 'This is rPI.'
  puts "This is an idea I've had since middle school"
  puts 'Nothing more, nothing less.'
  puts 'And it has a shitty name.'

  USE_STATIC_PI = true
  @pi_file = nil
  @pi_array = Array.new

  case USE_STATIC_PI
    when true
      @pi_file = File.open 'pi.txt' do |file|
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
    else
      puts 'Please define the USE_STATIC_PI global variable'
  end

  puts "The array containing the digits of Pi contains #{@pi_array.count} digits."

end