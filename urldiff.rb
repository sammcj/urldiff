#!/usr/bin/env ruby
# Author: Sam Mcleod
# https://github.com/sammcj/urldiff

require 'oily_png'
require 'imgkit'
require 'tempfile'
require 'optparse'
include ChunkyPNG::Color

options = {:first_url => nil, :second_url => nil, :keep_snaps => false, :output_cvs => nil }

optparse = OptionParser.new do|opts|
  # Help banner
  opts.banner = "Usage: urldiff.rb [options] -f URL1 -s URL2 ..."

  opts.on( '-f', '--first FIRST_URL', "First URL" ) do|first_url|
    options[:first_url] = first_url
  end
  opts.on( '-s', '--second SECOND_URL', "Second URL" ) do|second_url|
    options[:second_url] = second_url
  end
  opts.on( '-c', '--output FILENAME', 'Generate csv (append)' ) do|output_csv|
     options[:output_csv] = output_csv
  end
  opts.on( '-h', '--help', 'Display this screen' ) do
     puts opts
     exit
   end
end

optparse.parse!

puts options[:first_url]


stripped_first = options[:first_url].gsub(/^https?:\/\//, '')
stripped_second = options[:second_url].gsub(/^https?:\/\//, '')

output_diff = "DIFF-#{stripped_first}-#{stripped_second}.png"
output_change = "CHANGES-#{stripped_first}-#{stripped_second}.png"

puts "Rendering #{options[:first_url]} "
kit = IMGKit.new(options[:first_url], :quality => 50)
file = kit.to_file("#{stripped_first}.png")

puts "Rendering #{options[:second_url]} "
kit = IMGKit.new(options[:second_url], :quality => 50)
file = kit.to_file("#{stripped_second}.png")

puts "Calculating Diff... "
images = [
  ChunkyPNG::Image.from_file("#{stripped_first}.png"),
  ChunkyPNG::Image.from_file("#{stripped_second}.png"),
]

diff = []

images.first.height.times do |y|
  images.first.row(y).each_with_index do |pixel, x|
    diff << [x,y] unless pixel == images.last[x,y]
    images.last[x,y] = rgb(
      r(pixel) + r(images.last[x,y]) - 2 * [r(pixel), r(images.last[x,y])].min,
      g(pixel) + g(images.last[x,y]) - 2 * [g(pixel), g(images.last[x,y])].min,
      b(pixel) + b(images.last[x,y]) - 2 * [b(pixel), b(images.last[x,y])].min,
    )
  end
end

puts "pixels (total):     #{images.first.pixels.length}"
puts "pixels changed:     #{diff.length}"
puts "pixels changed (%): #{(diff.length.to_f / images.first.pixels.length) * 100}%",""

x, y = diff.map{ |xy| xy[0] }, diff.map{ |xy| xy[1] }

images.last.rect(x.min, y.min, x.max, y.max, ChunkyPNG::Color.rgb(0,255,0))

puts "Generating #{output_diff}",""
images.last.save(output_diff)

if options[:output_csv]
  puts "Appending output to #{options[:output_csv]}",""
  File.open(options[:output_csv], "a") do |f|
    f.write "#{options[:first_url]} vs #{options[:second_url]},#{(diff.length.to_f / images.first.pixels.length) * 100}%\n"
  end
end

