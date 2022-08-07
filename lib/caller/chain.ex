defmodule Web3MoveEx.Caller.Chain do
  @moduledoc """
  api about chain
  """

  alias Web3MoveEx.{Caller, HTTP}

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

  # TODO: impl others in
  # > https://www.postman.com/starcoinorg/workspace/starcoin-blockchain-api
end
