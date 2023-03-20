defmodule Web3MoveEx.Aptos.CliParser do
  import NimbleParsec

  @moduledoc """
    aptos CLI commands:
      $ aptos move init
  """

  aptos_signal =
    string("aptos")

  aptos_move_signal =
    string("aptos move")
  space = ascii_string([?\s], min: 0) |> ignore()
  name_param_signal =
    string("--name")
    |> ignore(space)
    |> concat(ascii_string([?_, ?0..?9, ?a..?z, ?A..?Z], min: 0))

  defparsec :cmd,
    choice([
      aptos_move_signal,
      aptos_signal
    ])
    |> ignore(space)
    |> optional() # behaviours
    |> optional(name_param_signal), debug: true # params
  def parse_cmd(cmd_str) do
    with {:ok, result, _, _, _, _} <- cmd(cmd_str) do
      {[first_arg], others} = Enum.split(result, 1)
      do_parse_cmd(first_arg, others)
    end
  end

  def do_parse_cmd("aptos", params), do: handle_aptos(params)
  def do_parse_cmd("aptos move", params), do: handle_aptos_move(params)

  def handle_aptos(params) do
    :aptos
  end

  def handle_aptos_move(params) do
    :aptos_move
  end
end
