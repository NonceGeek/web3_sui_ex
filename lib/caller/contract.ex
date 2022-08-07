defmodule Web3MoveEx.Caller.Contract do
  @moduledoc """
  api about contract
  """

  alias Web3MoveEx.{Caller, HTTP}

  @class "contract"

  @doc """
    for example:
      {
        "id":101,
        "jsonrpc":"2.0",
        "method":"contract.get_resource",
        "params":["0x0000000000000000000000000a550c18", "0x1::Account::Balance<0x1::STC::STC>"]
      }
  """
  def get_resource(endpoint, address, :stc) do
    # TODO
  end

  def get_resource(endpoint, address, resource_path) do
    body =
      @class
      |> Caller.build_method("get_resource")
      |> HTTP.json_rpc([address, resource_path])

    HTTP.post(endpoint, body)
  end

  @doc """
  Contract get code
  """
  def get_code(endpoint) do
    body =
      @class
      |> Caller.build_method("get_code")
      |> HTTP.json_rpc(["0x1::Account"])

    HTTP.post(endpoint, body)
  end

  @doc """
  Contract call_v2
  """
  def call_v2(endpoint, params) do
    body =
      @class
      |> Caller.build_method("call_v2")
      |> HTTP.json_rpc(params)

    HTTP.post(endpoint, body)
  end

  @doc """
  "0x1::Account::Balance<0x1::STC::STC>"
  """
  def build_resource_path(addr, module, struct) do
    "#{addr}::#{module}::#{struct}"
  end
end
