defmodule CliTest do
  use ExUnit.Case
  doctest UsAirportWeather.CLI

  import UsAirportWeather.CLI, only: [ parse_args: 1 ]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h",     "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "airport identifier returned if given" do
    assert parse_args(["KDTO"]) == "KDTO"
  end

  test ":help returned if more than one identifier is given" do
    assert parse_args(["KDTO", "KGED"]) == :help
  end

  test ":help returned if no identifier is given" do
    assert parse_args([]) == :help
  end
end
