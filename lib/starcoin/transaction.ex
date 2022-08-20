defmodule Web3MoveEx.Starcoin.Transaction do
  @moduledoc false

  import Web3MoveEx.Starcoin.Helpers

  @doc """
  Signing message
  """
  def signing_message(raw_tx) do
    raw_tx
    |> Bcs.encode()
    |> to_hex()
  end
end
