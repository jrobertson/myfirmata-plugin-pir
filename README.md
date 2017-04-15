# Detecting motion using the MyFirmata gem

    require 'myfirmata'
    require 'myfirmata-plugin-pir'
      
    mf = MyFirmata.new device_name: 'jessie', sps_address: 'sps',\
      plugins: {Pir: {pin: 2} }
    mf.start

The above code uses a PIR sensor connected to an Arduino on pin 2 to detect motion and publish the event to the SPS broker at least every minute.

## Resources

* myfirmata-plugin-pir https://rubygems.org/gems/myfirmata-plugin-pir

myfirmata plugin pir motion gem
