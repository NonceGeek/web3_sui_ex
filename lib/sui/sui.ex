defmodule Web3MoveEx.Sui do
  alias Web3MoveEx.Sui.RPC
  @moduledoc false
  @type key_schema() :: String.t()
  @type phrase() :: String.t()
  @type priv() :: String.t()
  @type sui_address() :: String.t()
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

  def sign(signer, tx_bytes) do

  end
end
