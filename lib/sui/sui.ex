defmodule Web3MoveEx.Sui do
  alias Web3MoveEx.Sui.RPC
  @moduledoc false
  @type key_schema() :: atom()
  @type phrase() :: String.t()
  @type priv() :: String.t()
  @type sui_address() :: String.t()
  # alias Web3MoveEx.Sui.Bcs.TransactionKind.ObjectRef
  alias Web3MoveEx.Sui.Bcs.IntentMessage
  alias Web3MoveEx.Sui.Bcs.IntentMessage.Intent

  def gen_acct(key_schema \\ :ed25519) do
    Web3MoveEx.Sui.Account.new(Atom.to_string(key_schema))
  end

  def get_balance(client \\ nil, sui_address) do
    res = client |> RPC.call("suix_getAllBalances", [sui_address])
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
    client |> RPC.call("suix_getAllCoins", [sui_address])
  end

  def move_call(
        client,
        account,
        package_object_id,
        module,
        function,
        type_arguments,
        arguments,
        gas \\ nil,
        gas_budget
      ) do
    unsafe_moveCall(
      client,
      account,
      package_object_id,
      module,
      function,
      type_arguments,
      arguments,
      gas,
      gas_budget
    )
  end

  def unsafe_moveCall(
        client,
        %Web3MoveEx.Sui.Account{sui_address_hex: sui_address_hex} = account,
        package_object_id,
        module,
        function,
        type_arguments,
        arguments,
        gas,
        gas_budget
      ) do
    {:ok, %{txBytes: tx_bytes}} =
      client
      |> RPC.unsafe_moveCall(
        sui_address_hex,
        package_object_id,
        module,
        function,
        type_arguments,
        arguments,
        gas,
        gas_budget
      )

    flag = Bcs.encode(Web3MoveEx.Sui.Bcs.IntentMessage.Intent.default())
    {:ok, signatures} = RPC.sign(account, flag <> :base64.decode(tx_bytes))

    client
    |> RPC.sui_executeTransactionBlock(
      tx_bytes,
      signatures,
      Web3MoveEx.Sui.RPC.ExecuteTransactionRequestType.wait_for_local_execution()
    )
  end

  def transfer(
        client,
        %Web3MoveEx.Sui.Account{sui_address_hex: sui_address_hex} = account,
        object_id,
        gas,
        gas_budget,
        recipient
      ) do
    gas = client |> select_gas(account, gas)
    gas_price = client |> RPC.suix_getReferenceGasPrice()

    kind =
      Web3MoveEx.Sui.Bcs.TransactionKind.transfer_object(recipient, object_ref(client, object_id))

    transaction_data =
      Web3MoveEx.Sui.Bcs.TransactionData.new(kind, sui_address_hex, gas, gas_budget, gas_price)

    intent_msg = %IntentMessage{intent: Intent.default(), data: {:v1, transaction_data}}
    client |> RPC.sui_executeTransactionBlock(account, intent_msg)
  end

  def unsafe_transfer(
        client,
        %Web3MoveEx.Sui.Account{sui_address_hex: sui_address} = account,
        object_id,
        gas \\ nil,
        gas_budget,
        recipient
      ) do
    {:ok, %{txBytes: tx_bytes}} =
      client |> RPC.unsafe_transferObject(sui_address, object_id, gas, gas_budget, recipient)

    flag = Bcs.encode(Web3MoveEx.Sui.Bcs.IntentMessage.Intent.default())
    {:ok, signatures} = RPC.sign(account, flag <> :base64.decode(tx_bytes))

    client
    |> RPC.sui_executeTransactionBlock(
      tx_bytes,
      signatures,
      Web3MoveEx.Sui.RPC.ExecuteTransactionRequestType.wait_for_local_execution()
    )
  end

  def select_gas(client, account, gas \\ nil)

  def select_gas(client, _account, nil) do
    # TODO: get then gas object
    :ok
  end

  def select_gas(client, _account, gas) do
    object_ref(client, gas)
  end

  def object_ref(client, object_id) do
    {:ok, %{data: %{objectId: object_id, version: ver, digest: digest}}} =
      client |> RPC.sui_get_object(object_id)

    {:ok, obj_bin} = :sui_nif.decode_pub(object_id)
    {obj_bin, ver, Base58.decode(digest)}
  end
end
