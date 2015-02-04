require 'rest_client'
require 'json'

class Forecast
  SCALING_FACTOR = 100

  def forecast_io_response
    url = "https://api.forecast.io/forecast/#{APIKEY}/#{LOCATION}"
    @response ||= RestClient.get(url)
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
