Gem::Specification.new do |s|
  s.name = 'keepass-static'
  s.version = '0.1.0'
  s.licenses = %w(MIT)
  s.summary = 'Ruby bindings to libkpass as static built native extensions'
  s.description = s.summary + ' ' # makes gem build STFU
  s.authors = ['Stefan Rusu']
  s.email = 'saltwaterc@gmail.com'
  s.files = Dir.glob('lib/*.rb') + Dir.glob('lib/*/keepass.*')
  s.homepage = 'https://github.com/SaltwaterC/keepass-static'
end
