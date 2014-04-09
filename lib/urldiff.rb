#!/usr/bin/env ruby
# Author: Sam Mcleod
# https://github.com/sammcj/urldiff

require 'oily_png'
require 'imgkit'
require 'tempfile'
require 'optparse'
require 'csv'
require 'wkhtmltoimg_binary'
include ChunkyPNG::Color

# Take option
options = {:first_url => nil, :second_url => nil, :keep_snaps => false, :output_cvs => nil, :input_csv => nil }

optparse = OptionParser.new do|opts|
  opts.banner = "Usage: urldiff.rb [options] -f URL1 -s URL2 ..."

  opts.on( '-f', '--first FIRST_URL', "First URL" ) do|first_url|
    options[:first_url] = first_url
  end
  opts.on( '-s', '--second SECOND_URL', "Second URL" ) do|second_url|
    options[:second_url] = second_url
  end
  opts.on( '-o', '--output FILENAME', 'Generate csv (append)' ) do|output_csv|
    options[:output_csv] = output_csv
  end
  opts.on( '-i', '--input FILENAME', 'Import csv site list' ) do|input_csv|
    options[:input_csv] = input_csv
    options[:site_list] = File.path(input_csv)
  end
  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end

optparse.parse!

# Read from CSV if enabled
if !options[:input_csv]
    site_list = "#{first_url},#{second_url}"
end

CSV.foreach(options[:site_list]) do |col|

  # Where col corresponds to a zero-based value/column in the csv
  first_url = col[0]
  second_url = col[1]

  # Strip http(s):// off for filenames
  stripped_first = first_url.gsub(/^https?:\/\//, '')
  stripped_second = second_url.gsub(/^https?:\/\//, '')

  output_diff = "DIFF-#{stripped_first}-#{stripped_second}.png"
  output_change = "CHANGES-#{stripped_first}-#{stripped_second}.png"

  # Render sites as PNG
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

  # Loop over each RGB pixel and calculate the difference
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

  # Create CSV output if enabled
  if options[:output_csv]
    puts "Appending output to #{options[:output_csv]}",""
    File.open(options[:output_csv], "a") do |f|
      f.write "#{first_url},#{second_url},#{(diff.length.to_f / images.first.pixels.length) * 100}%\n"
    end
  end
end

