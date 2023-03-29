defmodule Web3MoveEx.SuiTest do
  @moduledoc false
  alias Web3MoveEx.Sui.RPC
  alias Web3MoveEx.Sui
  use ExUnit.Case, async: true

  setup_all do
     {:ok, rpc} = RPC.connect()
     {:ok, {sui_address, _priv, _key_schema, _phrase}} = Sui.generate_priv()
    %{rpc: rpc, address: sui_address}
  end

  test "get_balance", %{rpc: rpc, address: account} do
    res = Sui.get_balance(rpc, account)
    assert {:ok, %{
          coinType: "0x2::sui::SUI",
          coinObjectCount: 0,
          totalBalance: 0,
          lockedBalance: {}
      }} == res
 end
end
