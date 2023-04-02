defmodule Web3MoveEx.Sui do
  alias Web3MoveEx.Sui.RPC
  @moduledoc false
  @type key_schema() :: String.t()
  @type phrase() :: String.t()
  @type priv() :: String.t()
  @type sui_address() :: String.t()
  alias Web3MoveEx.Sui.Bcs.TransactionKind.ObjectRef
@spec generate_priv(key_schema()) :: :error | {:ok, {sui_address(), priv(), key_schema(), phrase()}}
def generate_priv(key_schema \\"ed25519") do
    :sui_nif.new(%{:key_schema => key_schema})
end
def get_balance(client \\ nil, sui_address) do
    res = client |> RPC.call("sui_getAllBalances", [sui_address])
    case res do
        {:ok, []} ->  {:ok, %{
          coinType: "0x2::sui::SUI",
          coinObjectCount: 0,
          totalBalance: 0,
          lockedBalance: {}
      }}
      {:ok, [r]} -> {:ok, r}
      {:error, msg} ->
        {:error, msg}
    end
  end
  def get_all_coins(client \\ nil, sui_address) do
    client |> RPC.call("sui_getAllCoins", [sui_address])
  end
  def transfer(client, signer, to, object_id, gas_budget, gas \\ nil ) do
    gas = client |> select_gas(signer, gas)
    gas_price = client |> RPC.suix_getReferenceGasPrice()
    kind = ""
    transaction_data = Web3MoveEx.Sui.Bcs.TransactionData.new(kind, signer, gas, gas_budget, gas_price)
    intent_msg = %Web3MoveEx.Sui.Bcs.TransactionData.IntentMessage{intent: Web3MoveEx.Sui.Bcs.TransactionData.Intent.default,
    data: transaction_data }
    client |> RPC.sui_executeTransactionBlock(signer, intent_msg)
  end
  def select_gas(client, signer, gas \\ nil)
  def select_gas(client, _signer, nil) do
     :ok
  end
  def select_gas(client, signer, gas) do
    {:ok, %{data: %{objectId: _, version: ver, digest: digest}}} = client |> RPC.sui_get_object(gas)
    {_, object_id} = object_id |> String.split_at(2)
    %ObjectRef{ref: {:base64.decode(object_id), ver, Base58.decode(digest)}}
  end
end
