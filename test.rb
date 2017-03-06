require 'rpi_gpio'
require 'io/console'

RPi::GPIO.reset
RPi::GPIO.set_numbering :bcm

ON = true
OFF = false
IN1 = 12
IN2 = 13
PINS = [4, 17, 6]
@state = [OFF, OFF, OFF]

RPi::GPIO.setup IN1, :as => :input, :pull => :down
RPi::GPIO.setup IN2, :as => :input, :pull => :down

PINS.each do |p|
  RPi::GPIO.setup p, :as => :output
  RPi::GPIO.set_low p
end

def toggle(pin)
  if @state[pin] == OFF
    RPi::GPIO.set_high pin
  else
    RPi::GPIO.set_low pin
  end
  @state[pin] = !@state[pin]
end

def keyboard_loop
  loop do
    system("clear")
    puts "Press g/y/r or q to quitq"
    case STDIN.getch
    when "g"
      toggle(PINS[0])
    when "y"
      toggle(PINS[1])
    when "r"
      toggle(PINS[2])
    when "q"
      break
    else
      puts "Invalid input"
    end
  end
end

def pi_loop
  loop do
    pin_1 = RPi::GPIO.high? IN1
    pin_2 = RPi::GPIO.high? IN2
    @index ||= 0
    @count ||= 0    
    @count += 1
    system("clear")
    puts "Waiting for switch input...#{@count} Pin 1 - #{pin_1} | Pin 2 - #{pin_2}"
    
    if pin_1 && pin_2
      break
    elsif pin_1
      puts "up"
      @index += 1
      @index = 0 if @index > 3
    elsif pin_2
      puts "down"
      @index -= 1
      @index = 3 if @index < 0
    end
    sleep 0.5
  end
end


puts "Press K for keyboard or P for Pi input:"

if STDIN.getch == "k"
  keyboard_loop
else
  pi_loop
end

