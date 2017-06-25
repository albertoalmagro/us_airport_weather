defmodule UsAirportWeather.CLI do

  import UsAirportWeather.PrettyPrinter, only: [ pretty_print: 1 ]

  @moduledoc """
  Handle the command line parsing and the dispatch to the various functions that end
  up generating a weather report about a given airport in the US.
  """

  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  @doc """
  `argv` can be -h or --help, which returns :help.

  Otherwise it is an US airport identifier.

  Return a doc xml element or `help` if help was given.

  ## Examples

      iex> UsAirportWeather.CLI.parse_args ["-h", "anything"]
      :help

      iex> UsAirportWeather.CLI.parse_args ["KDTO"]
      "KDTO"
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean ],
                                     aliases:  [ h:    :help    ])
    case parse do
      { [ help: true ], _, _ } ->
        :help

      { _, [ identifier ], _ } ->
        identifier

      _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: us_airport_weather <identifier>
    """
    System.halt(0)
  end
  def process(identifier) do
    UsAirportWeather.NOAA.fetch(identifier)
    |> decode_response
    |> pretty_print
  end

  def decode_response({ :ok, body }) do
    { doc, _ } = body |> :binary.bin_to_list |> :xmerl_scan.string
    doc
  end
  def decode_response({ :error, error }) do
    { _, message } = List.keyfind(error, "message", 0)
    IO.puts "Error fetching from NOAA: #{message}"
    System.halt(2)
  end
end
