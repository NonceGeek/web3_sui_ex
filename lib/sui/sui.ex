defmodule Web3MoveEx.Sui do
  alias Web3MoveEx.Sui.RPC
  @moduledoc false
  @type key_schema() :: String.t()
  @type phrase() :: String.t()
  @type priv() :: String.t()
  @type sui_address() :: String.t()
  alias Web3MoveEx.Sui.Bcs.TransactionKind.ObjectRef
  alias Web3MoveEx.Sui.Bcs.IntentMessage
  alias Web3MoveEx.Sui.Bcs.IntentMessage.Intent

  @spec generate_priv(key_schema()) ::
          :error | {:ok, Web3MoveEx.Sui.Account}
  def generate_priv(key_schema \\ "ed25519") do
      Web3MoveEx.Sui.Account.new(key_schema)
  end

  def get_balance(client \\ nil, sui_address_hex) do
    res = client |> RPC.call("suix_getAllBalances", [sui_address_hex])

    case res do
      {:ok, []} ->
        {:ok,
         %{
           coinType: "0x2::sui::SUI",
           coinObjectCount: 0,
           totalBalance: 0,
           lockedBalance: {}
         }}

      {:ok, [r]} ->
        {:ok, r}

      {:error, msg} ->
        {:error, msg}
    end
  end

  def get_all_coins(client \\ nil, sui_address) do
    client |> RPC.call("sui_getAllCoins", [sui_address])
  end

  def transfer(client, account, to, object_id, gas_budget, gas \\ nil) do
    gas = client |> select_gas(account, gas)
    gas_price = client |> RPC.suix_getReferenceGasPrice()
    kind = Web3MoveEx.Sui.Bcs.TransactionKind.transfer_object(to, object_ref(client, object_id))

    transaction_data =
      Web3MoveEx.Sui.Bcs.TransactionData.new(kind, account, gas, gas_budget, gas_price)

    intent_msg = %IntentMessage{intent: Intent.default(), data: transaction_data}
    client |> RPC.sui_executeTransactionBlock(account, intent_msg)
  end
  def unsafe_transfer(client, %Web3MoveEx.Sui.Account{sui_address_hex: sui_address}=account, object_id, gas \\ "null", gas_budget, recipient) do
      {:ok, %{txBytes: tx_bytes}} = client |> RPC.unsafe_transferObject(sui_address,object_id, gas, gas_budget, recipient)
      flag =  Bcs.encode(Web3MoveEx.Sui.Bcs.IntentMessage.Intent.default)
      {:ok, signatures} = RPC.sign(account, flag <> :base64.decode(tx_bytes))
      client |> RPC.sui_executeTransactionBlock(tx_bytes, signatures, Web3MoveEx.Sui.RPC.ExecuteTransactionRequestType.wait_for_local_execution())
  end

  def select_gas(client, account, gas \\ nil)

  def select_gas(client, _account, nil) do
    :ok
  end

  def select_gas(client, _account, gas) do
    object_ref(client, gas)
  end

  def object_ref(client, object_id) do
    {:ok, %{data: %{objectId: _, version: ver, digest: digest}}} =
      client |> RPC.sui_get_object(object_id)

    {_, object_id} = object_id |> String.split_at(2)
    {:base64.decode(object_id), ver, Base58.decode(digest)}
  end
end
