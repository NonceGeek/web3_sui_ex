defmodule Web3MoveEx.Starcoin.Caller.Txpool do
  @moduledoc """
  transaction namespace
  """

  alias Web3MoveEx.HTTP
  alias Web3MoveEx.Starcoin.Caller

  @class "txpool"

  @doc """
  submit raw transaction
  """
  def submit_hex_transaction(endpoint, signed_data) do
    body =
      @class
      |> Caller.build_method("submit_hex_transaction")
      |> HTTP.json_rpc([signed_data])

    HTTP.post(endpoint, body)
  end
end
