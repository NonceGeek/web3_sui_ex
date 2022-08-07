defmodule Web3MoveEx.Caller.Chain do
  alias Web3MoveEx.Caller

  @moduledoc """
    api about chain
  """
  @class "chain"
  def get_id(endpoint, id \\ 100) do
    body =
      @class
      |> Caller.build_method("id")
      |> Http.json_rpc(id)

    Http.post(endpoint, body)
  end

  def get_info(endpoint, id \\ 100) do
    body =
      @class
      |> Caller.build_method("info")
      |> Http.json_rpc(id)

    Http.post(endpoint, body)
  end

  def get_block_by_number(endpoint, num) do
    body =
      @class
      |> Caller.build_method("get_block_by_number")
      |> Http.json_rpc([num])

    Http.post(endpoint, body)
  end

  # TODO: impl others in
  # > https://www.postman.com/starcoinorg/workspace/starcoin-blockchain-api
end
