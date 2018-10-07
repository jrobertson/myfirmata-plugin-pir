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
    @settings, @variables = settings, {debug: false}.merge(variables)
    @debug = @variables[:debug
                        ]
    @pinx = @settings[:pin] || 2

    @arduino.pin_mode @pinx, ArduinoFirmata::INPUT
    @duration = settings[:duration] || '1 minute'
    
  end
    
  def start()
         
    count = 0
    
    duration = @duration    
    puts 'duration: ' + duration.inspect if @debug
    notifier = @variables[:notifier]
    topic = @variables[:device_id]
    msg = @settings[:msg] || 'motion'    
    pinx = @pinx
    threshold = if @settings[:threshold] then
      @settings[:threshold]
    else
      ChronicDuration.parse(duration) > 30 ? 5 : 0
    end
    
    t1 = Time.now - (ChronicDuration.parse(duration) + 10)   
    puts 't1: ' + t1.inspect if @debug
    
    puts 'ready to detect PIR sensor'    
    
    debug = @debug
    
    @arduino.on :digital_read do |pin, high|

      if pin == pinx and high then
                
        count += 1
        puts 'count: ' + count.inspect if debug

        if Time.now > t1 + ChronicDuration.parse(duration)  then

          if count > threshold then
            
            
            fqm = if ChronicDuration.parse(duration) == 1 then
              "%s/motion: detected within the past second" % topic
            elsif count == 1
              "%s/motion: detected once within the past %s"% [topic, duration]
            elsif count == 2
              "%s/motion: detected twice within the past %s" % \
                [topic, duration]
            else
              "%s/motion: detected %s times within the past %s" % \
                [topic, count, duration]
            end
            
            notifier.notice fqm 
          end
          t1 = Time.now
          count = 0
        end        
        
      end
    end

  end  
  
  alias on_start start
    
end
