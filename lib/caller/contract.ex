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
  # def get_resource(endpoint, address, :stc) do
  #   # TODO
  # end

  def get_resource(endpoint, address, resource_path) do
    body =
      @class
      |> Caller.build_method("get_resource")
      |> HTTP.json_rpc([address, resource_path])

    HTTP.post(endpoint, body)
  end

  @doc """
    Contract get code:
      get_code( "http://localhost:9851", "0x1::Account")
  """
  def get_code(endpoint, module_path) do
    body =
      @class
      |> Caller.build_method("get_code")
      |> HTTP.json_rpc([module_path])

    HTTP.post(endpoint, body)
  end

  @doc """
    Contract call_v2.
    Metion:
    0x01) func id could be built by `Caller.build_namespace`
    0x02) hex can be tranfered into starcoin_bytes in type_translator
    example:
      Web3MoveEx.Caller.Contract.call_v2(
        "http://localhost:9851",
        "0x1168e88ffc5cec53b398b42d61885bbb::EthSigVerifier::verify_eth_sig",
        [],
          ["x\"90a938f7457df6e8f741264c32697fc52f9a8f867c52dd70713d9d2d472f2e415d9c94148991bbe1f4a1818d1dff09165782749c877f5cf1eff4ef126e55714d1c\"",  "x\"29c76e6ad8f28bb1004902578fb108c507be341b\"",  "x\"b453bd4e271eed985cbab8231da609c4ce0a9cf1f763b6c1594e76315510e0f1\""])
  """

  @spec call_v2(String.t(), String.t(), list()) :: any()
  def call_v2(endpoint, function_id, args) do
    body =
      @class
      |> Caller.build_method("call_v2")
      |> HTTP.json_rpc(build_payload(function_id, args))

    HTTP.post(endpoint, body)
  end

  @spec call_v2(String.t(), String.t(), list(), list()) :: any()
  def call_v2(endpoint, function_id, type_args, args) do
    body =
      @class
      |> Caller.build_method("call_v2")
      |> HTTP.json_rpc(build_payload(function_id, type_args, args))

    HTTP.post(endpoint, body)
  end


  def build_payload(function_id, args) do
    [%{
      function_id: function_id,
      type_args: [],
      args: args
    }]
  end
  def build_payload(function_id, type_args, args) do
    [%{
      function_id: function_id,
      type_args: type_args,
      args: args
    }]
  end

end
