require 'pi_piper'
include PiPiper

pin1 = PiPiper::Pin.new(:pin => 19, :direction => :in, :pull => :up)
pin2 = PiPiper::Pin.new(:pin => 26, :direction => :in, :pull => :up)

watch pin1 do
  puts "pin1 changed"
end

watch pin2 do
  puts "pin2 changed"
end

PiPiper.wait
