#!/usr/bin/env ruby

# file: myfirmata-plugin-pir.rb

# a plugin for the myfirmata gem

require 'chronic_duration'


# note:
# the conditional statement for publishing a notice was based on the 
# code from the humble_rpi-plugin-pir gem

class MyFirmataPluginPir


  def initialize(arduino, settings: {}, variables: {})
    
    @arduino = arduino
    @settings, @variables = settings, variables
    @pinx = @settings[:pin] || 2

    @arduino.pin_mode @pinx, ArduinoFirmata::INPUT
    @duration = settings[:duration] || '1 minute'
    
  end
    
  def start()
         
    count = 0
    
    duration = @duration    
    notifier = @variables[:notifier]
    topic = @variables[:device_id]
    msg = @settings[:msg] || 'motion'
    pinx = @pinx
    
    t1 = Time.now - (ChronicDuration.parse(duration) + 10)   
    
    puts 'ready to detect PIR sensor'    
    
    @arduino.on :digital_read do |pin, high|

      if pin == pinx and high then
                
        count += 1

        if Time.now > t1 + ChronicDuration.parse(duration)  then

          notifier.notice \
              "%s/motion: detected %s times within the past %s" % \
              [topic, count, duration]
          t1 = Time.now
          count = 0
        end        
        
      end
    end

  end  
  
  alias on_start start
    
end
