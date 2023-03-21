defmodule Web3MoveEx.ModuleHandler.Aptos.Coin do
  @moduledoc """
    0x1::coin
  """
  # alias Web3MoveEx.Aptos
  alias Web3MoveEx.Aptos.RPC

  @resources %{
    coin_store: "0x1::coin"
  }

  def get_coin_store(client, acct) do
    with {:ok, result} <- RPC.get_resource(
      client,
      acct,
      "#{@resources.coin_store}::CoinStore<0x1::aptos_coin::AptosCoin>") do
      result.data
    end
  end
end
