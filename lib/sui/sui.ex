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

  def get_faucet(address_hex) do
    {:ok, client} = RPC.connect(:faucet)
    # {:ok, _} = RPC.get_faucet(client, account)
    # account
  end

  def get_balance(client, sui_address) do
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

  def get_all_coins(client, sui_address) do
    client |> RPC.call("suix_getAllCoins", [sui_address])
  end

  def get_objects_by_owner(client, sui_address) do
    client |> RPC.call("suix_getOwnedObjects", [sui_address])
  end

  defdelegate get_object(client, object_id, options \\ :default), to: RPC

  def sui_getMoveFunctionArgTypes(client, package, module, function) do
    client |> RPC.call("sui_getMoveFunctionArgTypes", [package, module, function])
  end

  def sui_getNormalizedMoveFunction(client, package, module, function) do
    client |> RPC.call("sui_getNormalizedMoveFunction", [package, module, function])
  end

  def sui_getNormalizedMoveModule(client, package, module) do
    client |> RPC.call("sui_getNormalizedMoveModule", [package, module])
  end

  def sui_getNormalizedMoveModulesByPackage(client, package) do
    client |> RPC.call("sui_getNormalizedMoveModulesByPackage", [package])
  end

  def sui_getNormalizedMoveStruct(client, package, module, struct) do
    client |> RPC.call("sui_getNormalizedMoveStruct", [package, module, struct])
  end
  def suix_getReferenceGasPrice(client) do
    client |> RPC.call("suix_getReferenceGasPrice", [])
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

  def unsafe_mergeCoins(client, account, primary_coin, coin_to_merge, gas \\ nil, gas_budget) do
    client
    |> RPC.unsafe_call(account, "unsafe_mergeCoins", [
      primary_coin,
      coin_to_merge,
      gas,
      gas_budget
    ])
  end

  def unsafe_moveCall(
        client,
        %Web3MoveEx.Sui.Account{sui_address_hex: sui_address_hex} = account,
        package_object_id,
        module,
        function,
        type_arguments,
        arguments,
        gas \\ nil,
        gas_budget
      ) do
    client
    |> RPC.unsafe_call(account, "unsafe_moveCall", [
      package_object_id,
      module,
      function,
      type_arguments,
      arguments,
      gas,
      gas_budget
    ])
  end

  def unsafe_pay(client, account, input_coins, recipients, amounts, gas \\ nil, gas_budget) do
    client
    |> RPC.unsafe_call(account, "unsafe_pay", [input_coins, recipients, amounts, gas, gas_budget])
  end

  def unsafe_payAllSui(client, account, input_coins, recipients, gas_budget) do
    client |> RPC.unsafe_call(account, "unsafe_payAllSui", [input_coins, recipients, gas_budget])
  end

  def unsafe_paySui(client, account, input_coins, recipients, amounts, gas_budget) do
    client
    |> RPC.unsafe_call(account, "unsafe_paySui", [input_coins, recipients, amounts, gas_budget])
  end

  def unsafe_push(client, account, compiled_modules, dependencies, gas \\ nil, gas_budget) do
    client
    |> RPC.unsafe_call(account, "unsafe_push", [compiled_modules, dependencies, gas, gas_budget])
  end

  def unsafe_requestAddStake(client, account, coins, amount, validator, gas \\ nil, gas_budget) do
    client
    |> RPC.unsafe_call(account, "unsafe_requestAddStake", [
      coins,
      amount,
      validator,
      gas,
      gas_budget
    ])
  end

  def unsafe_requestWithdrawStake(client, account, staked_sui, gas \\ nil, gas_budget) do
    client
    |> RPC.unsafe_call(account, "unsafe_requestWithdrawStake", [staked_sui, gas, gas_budget])
  end

  def unsafe_splitCoin(client, account, coin_object_id, split_amounts, gas \\ nil, gas_budget) do
    client
    |> RPC.unsafe_call(account, "unsafe_splitCoin", [
      coin_object_id,
      split_amounts,
      gas,
      gas_budget
    ])
  end

  def unsafe_splitCoinEqual(client, account, coin_object_id, split_count, gas \\ nil, gas_budget) do
    client
    |> RPC.unsafe_call(account, "unsafe_splitCoinEqual", [
      coin_object_id,
      split_count,
      gas,
      gas_budget
    ])
  end

  def unsafe_transfer(
        client,
        account,
        object_id,
        gas_budget,
        recipient,
        gas \\ nil
      ) do
    client |> RPC.unsafe_call(account, "unsafe_transfer", [object_id, gas, gas_budget, recipient])
  end

  def unsafe_transferSui(client, account, sui_object_id, gas_budget, recipient, amount) do
    client
    |> RPC.unsafe_call(account, "unsafe_transferSui", [
      sui_object_id,
      gas_budget,
      recipient,
      amount
    ])
  end

  # def transfer(
  #       client,
  #       %Web3MoveEx.Sui.Account{sui_address_hex: sui_address_hex} = account,
  #       object_id,
  #       gas,
  #       gas_budget,
  #       recipient
  #     ) do
  #   gas = client |> select_gas(account, gas)
  #   gas_price = client |> RPC.suix_getReferenceGasPrice()

  #   kind =
  #     Web3MoveEx.Sui.Bcs.TransactionKind.transfer_object(recipient, object_ref(client, object_id))
  #   transaction_data =
  #     Web3MoveEx.Sui.Bcs.TransactionData.new(kind, sui_address_hex, gas, gas_budget, gas_price)

  #   intent_msg = %IntentMessage{intent: Intent.default(), data: {:v1, transaction_data}}
  #   client |> RPC.sui_executeTransactionBlock(account, intent_msg)
  # end

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
      client |> RPC.get_object(object_id)

    {:ok, obj_bin} = :sui_nif.decode_pub(object_id)
    {obj_bin, ver, Base58.decode(digest)}
  end
end
