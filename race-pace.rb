#!/usr/bin/ruby

# Race pace calculator.  Given a distance and a target time,
# prints the required race pace and mile/KM splits.

require 'optparse.rb'

OptionParser.new do |parser|
	parser.banner = <<END
Usage: #{$0} <distance> <time>

Display target times for each mile / KM for a race
of <distance> miles or KM with a target finishing time
of <time>.  Time is specified as MM, MM:SS or HH:MM:SS
END
end.parse!

def secs_to_mm(secs)
	mm = (secs / 60).to_s
	ss = (secs % 60).to_s.rjust(2,'0')
	return "#{mm}:#{ss}"
end

if ARGV.length < 2
	$stderr.puts "Distance and time must be specified"
	exit 1
end

dist_match = /([0-9\.]+)([a-z]+)?/.match(ARGV[0])
if !dist_match
	$stderr.puts "Distance must be numeric.  eg. 13.1, 10km.  Unit default to miles."
	exit 1
end

dist_unit = dist_match[2] || "mile"
dist = dist_match[1]
hour, min, sec = [0, 0, 0]
time_parts = ARGV[1].split(':').map {|e| e.to_i}
case time_parts.length
	when 1
		min = time_parts[0]
	when 2
		min, sec = time_parts
	when 3
		hour, min, sec = time_parts
end

dist = dist.to_f
time_in_s = sec + (min * 60) + (hour * 60 * 60)

if dist < 1 || time_in_s < 1
	$stderr.puts "Distance and time must be numeric and >= 1"
	exit 1
end

secs_per_dist = (time_in_s / dist).ceil
last_dist = dist.floor

puts "Pace: #{secs_to_mm(secs_per_dist)} min/#{dist_unit}"
puts ""
puts "Splits:\n"
for i in (1..last_dist)
	target_time_secs = secs_per_dist * i
	puts " #{i.to_s.rjust(2)} : #{secs_to_mm(target_time_secs)}"
end
