defmodule Web3MoveEx.Sui do
  alias Web3MoveEx.Sui.RPC
  @moduledoc false
  @type key_schema() :: atom()
  @type phrase() :: String.t()
  @type priv() :: String.t()
  @type sui_address() :: String.t()

  @spec gen_acct(key_schema()) :: :error | {:ok, {sui_address(), priv(), key_schema(), phrase()}}
  def gen_acct(key_schema \\ :ed25519) do
    {:ok, {sui_addr, priv, _key_schema, phrase}} = :sui_nif.new(%{:key_schema => Atom.to_string(key_schema)})
    {:ok, %{addr: sui_addr, priv: priv, key_schema: key_schema, phrase: phrase}}
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
end
