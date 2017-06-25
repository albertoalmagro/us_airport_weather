defmodule UsAirportWeather.PrettyPrinter do
  def pretty_print(doc) do
    with location          = valueForXmlElement(doc, 'location'),
         station_id        = valueForXmlElement(doc, 'station_id'),
         time              = valueForXmlElement(doc, 'observation_time'),
         temp_c            = valueForXmlElement(doc, 'temp_c'),
         wind_kt           = valueForXmlElement(doc, 'wind_kt'),
         wind_dir          = valueForXmlElement(doc, 'wind_dir'),
         pressure          = valueForXmlElement(doc, 'pressure_string'),
         dewpoint_c        = valueForXmlElement(doc, 'dewpoint_c'),
         humidity          = valueForXmlElement(doc, 'relative_humidity'),
         visib_mi          = valueForXmlElement(doc, 'visibility_mi'),
         { visib_mi_p, _ } = Float.parse(to_string(visib_mi)),
         visibility        = visib_mi_p * 1.60934
    do
         IO.puts """
         Weather Observation for #{location} (#{station_id})
         ------------------------------------------------------
         Observation time:  #{time}
         Temperature C:     #{temp_c}
         Dewpoint    C:     #{dewpoint_c}
         Wind:              #{wind_kt} kt, #{wind_dir}
         Pressure:          #{pressure}
         Relative humidity: #{humidity}%
         Visibility:        #{to_string(visibility)} Kms
         """
    end
  end

  defp valueForXmlElement(doc, element) do
    el = :xmerl_xpath.string('/current_observation/' ++ element, doc)
    [{:xmlElement, _, _, _, _, _, _, _, [{:xmlText, _, _, _, text, :text}], _, _, _}] = el
    text
  end
end
