defmodule Web3MoveEx.Aptos.AptosTest do
  @moduledoc false
  use ExUnit.Case, async: true

  setup_all do
     {:ok, rpc} = Web3MoveEx.Aptos.RPC.connect()
     priv = Web3MoveEx.Crypto.generate_priv()
     {:ok, account} = Web3MoveEx.Aptos.Account.from_private_key(priv)
    %{rpc: rpc, ac: account}
  end

  test "call_function", %{rpc: _rpc, ac: account} do
     f = %Web3MoveEx.Aptos.Types.Function{
   address: 0x1,
   is_entry: true,
   module: "coin",
   name: "transfer",
   params: [:address, :u64, {:vector, :string}],
   return: [],
   type_params: [%{"constraints" => []}],
   visibility: :public
   }
   _payload = Web3MoveEx.Aptos.call_function(f, ["0x1::aptos_coin::AptosCoin"], [account.address, 100,["abc", "456"]])
   assert _payload=%Web3MoveEx.Aptos.Types.TransactionPayload.EntryFunction{
            address: <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1>>,
            args: [<<41, 162, 121, 42, 224, 67, 135, 192, 87, 224, 247, 47, 194, 10, 136, 206, 82, 195, 11, 155, 106, 160, 108, 190, 1, 247, 114, 248, 28, 46, 196, 196>>, <<100, 0, 0, 0, 0, 0, 0, 0>>, <<2, 3, 97, 98, 99, 3, 52, 53, 54>>],
            function: "transfer",
            module: "coin",
            type_args: [struct: "0x1::aptos_coin::AptosCoin"]}
    end
end
