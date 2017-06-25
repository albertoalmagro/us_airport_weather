defmodule UsAirportWeather.NOAA do

  require Logger

  def fetch(identifier) do
    Logger.info "Fetching weather observation from NOAA for #{identifier}"
    weather_conditions_url_for(identifier)
    |> HTTPoison.get
    |> handle_response
  end

  # Use a module attribute to fetch the value at compile time
  @noaa_url Application.get_env(:us_airport_weather, :noaa_url)
  defp weather_conditions_url_for(identifier) do
    "#{@noaa_url}/#{identifier}.xml"
  end

  def handle_response({ :ok, %{status_code: 200, body: body}}) do
    Logger.info "Successful response"
    Logger.debug fn -> inspect(body) end
    {:ok, body}
  end
  def handle_response({ _, %{status_code: status, body: body}}) do
    Logger.error "Error #{status} returned"
    {:error, body}
  end
end
