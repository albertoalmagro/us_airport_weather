defmodule UsAirportWeather.CLI do

  @moduledoc """
  Handle the command line parsing and the dispatch to the various functions that end
  up generating a weather report about a given airport in the US.
  """

  def main(argv) do
    parse_args(argv)
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
end
