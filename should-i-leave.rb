require 'clamp'
require 'sparkr'

require_relative 'lib/forcast'

APIKEY = ENV['FORCAST_IO_KEY']
LOCATION = ENV['LOCATION']

Clamp do
  def execute
    f = Forecast.new
    puts "Its currently #{f.currentTemprature} and #{f.currentConditions}"
    puts "Precipitation"
    puts "\tProbability"
    puts Sparkr.sparkline f.precipProbability
    puts "\tIntensity"
    puts Sparkr.sparkline f.precipIntensity
    puts "\tAccumulation"
    puts Sparkr.sparkline f.precipAccumulation

    if f.alerts
      f.alerts.each do |a|
        puts a['title']
        puts "\t" + a['description'].split("\n").join("\n\t")
      end
    end
  end
end
