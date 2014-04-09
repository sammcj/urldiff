Gem::Specification.new do |s|
  s.name        = 'urldiff'
  s.version     = '0.0.7'
  s.date        = '2014-04-09'
  s.summary     = "Computes and displays the visual differences between two URLs"
  s.description = "Computes and displays the visual differences between two URLs"
  s.authors     = ["Sam McLeod"]
  s.files       = ["lib/urldiff.rb"]
  s.homepage    =
    'https://github.com/sammcj/urldiff'
  s.license       = 'GPLv2'
  s.required_ruby_version = ">= 2.0"
  s.add_runtime_dependency 'oily_png'
  s.add_runtime_dependency 'imgkit'
  s.add_runtime_dependency 'wkhtmltoimg_binary'
end
