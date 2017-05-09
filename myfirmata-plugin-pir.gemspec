Gem::Specification.new do |s|
  s.name = 'myfirmata-plugin-pir'
  s.version = '0.1.1'
  s.summary = 'A PIR motion sensing plugin for the MyFirmata gem. Publishes ' + 
    'a message to the SPS broker at a set inteval whenever motion is detected.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/myfirmata-plugin-pir.rb']
  s.add_runtime_dependency('chronic_duration', '~> 0.10', '>=0.10.6')
  s.signing_key = '../privatekeys/myfirmata-plugin-pir.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/myfirmata-plugin-pir'
end
