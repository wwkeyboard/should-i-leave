require 'clamp'
require 'rest_client'
require 'json'
require 'sparkr'

APIKEY = ENV['FORCAST_IO_KEY']
LOCATION = ENV['LOCATION']

class Forecast
  SCALING_FACTOR = 100

  def forecast_io_response
    @response ||= RestClient.get("https://api.forecast.io/forecast/#{APIKEY}/#{LOCATION}")
  end

  def weather_data
    @data ||= JSON.parse forecast_io_response.body
  end

  def minutely
    weather_data['minutely']
  end

  def precipIntensity
    weather_data['minutely']['data'].map{|m| m['precipIntensity'] * SCALING_FACTOR}
  end

  def precipProbability
    weather_data['minutely']['data'].map{|m| m['precipProbability'] * SCALING_FACTOR}
  end

  def precipAccumulation
    weather_data['minutely']['data'].map{|m| m.fetch('precipAccumulation', 0) * SCALING_FACTOR}
  end

  def currentConditions
    weather_data['currently']['summary']
  end

  def currentTemprature
    weather_data['currently']['temperature']
  end

  def alerts
    weather_data['alerts']
  end
end

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

    unless f.alerts.empty?
      f.alerts.each do |a|
        puts a['title']
        puts "\t" + a['description'].split("\n").join("\n\t")
      end
    end
  end
end
