defmodule Web3MoveEx.Starcoin.Caller.Chain do
  @moduledoc """
  api about chain

  TODO: impl others in https://www.postman.com/starcoinorg/workspace/starcoin-blockchain-api
  """

  alias Web3MoveEx.HTTP
  alias Web3MoveEx.Starcoin.Caller

  @class "chain"

  def get_id(endpoint, id \\ 100) do
    body =
      @class
      |> Caller.build_method("id")
      |> HTTP.json_rpc(id)

    HTTP.post(endpoint, body)
  end

  def get_info(endpoint, id \\ 100) do
    body =
      @class
      |> Caller.build_method("info")
      |> HTTP.json_rpc(id)

    HTTP.post(endpoint, body)
  end

  def get_block_by_number(endpoint, num) do
    body =
      @class
      |> Caller.build_method("get_block_by_number")
      |> HTTP.json_rpc([num])

    HTTP.post(endpoint, body)
  end

  @doc """
  Get transaction info by tx_hash

  ## Example

    iex> Web3MoveEx.Starcoin.Caller.Chain.get_transaction_info("http://localhost:9851", "0xa23138f12b9f8221227dfebda5001bef176f9fcc9ce0c3eab2928d0a342bc6f1")
    {:ok, %{id: 1, jsonrpc: "2.0", result: %{}}}

  """
  def get_transaction_info(endpoint, tx_hash) do
    body =
      @class
      |> Caller.build_method("get_transaction_info")
      |> HTTP.json_rpc([tx_hash])

    HTTP.post(endpoint, body)
  end

  @doc """
  Get transaction by tx_hash

  ## Example

    iex> Web3MoveEx.Starcoin.Caller.Chain.get_transaction("http://localhost:9851", "0xa23138f12b9f8221227dfebda5001bef176f9fcc9ce0c3eab2928d0a342bc6f1")
    {:ok, %{id: 1, jsonrpc: "2.0", result: %{}}}

  """
  def get_transaction(endpoint, tx_hash) do
    body =
      @class
      |> Caller.build_method("get_transaction")
      |> HTTP.json_rpc([tx_hash])

    HTTP.post(endpoint, body)
  end
end
