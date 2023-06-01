defmodule Web3SuiEx.Starcoin.Transaction.Function do
  @moduledoc false

  require Logger

  alias Web3SuiEx.Starcoin.Transaction
  alias Web3SuiEx.Starcoin.Caller.Contract
  alias Web3SuiEx.Starcoin.Encoder

  defstruct address: nil,
            module: nil,
            name: nil,
            args: [],
            ty_args: [],
            returns: []

  @doc """
  transaction script function all.

  ## Examples

    iex> endpoint = Web3SuiEx.Starcoin.Client.connect()
    iex> Web3SuiEx.Starcoin.Transaction.Function.call(endpoint, "0x1::TransferScripts::peer_to_peer_v2", ["0x1::STC::STC"], [0x1, 1])
    %Web3SuiEx.Starcoin.Transaction.TransactionPayload.ScriptFunction{
      address: <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1>>,
      args: [
        <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1>>,
        <<1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>>
      ],
      function: "peer_to_peer_v2",
      module: "TransferScripts",
      type_args: [
        struct: %Web3SuiEx.Starcoin.Transaction.TypeTag.StructTag{
          address: <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1>>,
          module: "STC",
          name: "STC",
          type_args: []
        }
      ]
    }

  """
  def call(endpoint, func_name, type_args, args) do
    with {:ok, %{result: result}} <- Contract.resolve_function(endpoint, func_name) do
      func = %__MODULE__{
        address: result.module_name.address,
        module: result.module_name.name,
        name: result.name,
        args: build_arg(result),
        ty_args: result.ty_args,
        returns: result.returns
      }

      encoded_args = Encoder.encode(args, func.args)

      Transaction.script_function(
        func.address,
        func.module,
        func.name,
        type_args,
        encoded_args
      )
    else
      _ -> Logger.error("can not resolve function: #{func_name}")
    end
  end

  defp build_arg(%{args: args}) do
    args
    |> Enum.map(fn item ->
      item.type_tag
      |> String.downcase()
      |> String.to_atom()
    end)
  end
end
