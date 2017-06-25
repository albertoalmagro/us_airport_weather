defmodule UsAirportWeather.NOAA do

  def fetch(identifier) do
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
    {:ok, body}
  end
  def handle_response({ _, %{status_code: _, body: body}}) do
    {:error, body}
  end
end
