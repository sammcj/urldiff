#!/usr/bin/env ruby
# Author: Sam Mcleod

#require 'chunky_png'
require 'oily_png'
require 'imgkit'
require 'tempfile'
include ChunkyPNG::Color

if ARGV.empty?
  puts "","Takes a protocol and two URLs, renders them as images and outputs a diff",""
  puts "Usage: urldiff.rb [first_url] [second_url]"
  puts "Example: urldiff.rb http://www.google.com.au https://www.google.co.nz",""
  puts "Requires gems: chunky_png and imgkit",""
  puts "Warning: Full of bugs!",""
  exit
end

first_url = ARGV[0]
second_url = ARGV[1]

stripped_first = first_url.gsub(/^https?:\/\//, '')
stripped_second = second_url.gsub(/^https?:\/\//, '')

output_diff = "DIFF-#{stripped_first}-#{stripped_second}.png"
output_change = "CHANGES-#{stripped_first}-#{stripped_second}.png"

puts "Rendering #{first_url} "
kit = IMGKit.new(first_url, :quality => 50)
file = kit.to_file("#{stripped_first}.png")

puts "Rendering #{second_url} "
kit = IMGKit.new(second_url, :quality => 50)
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

