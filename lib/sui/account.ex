defmodule Web3MoveEx.Sui.Account do
  defstruct [
    :sui_address,
    :sui_address_hex,
    :priv_key,
    :priv_key_base64,
    :key_schema,
    :phrase
  ]

  @type t() :: %__MODULE__{
          sui_address: binary(),
          sui_address_hex: binary(),
          priv_key: nil | binary(),
          priv_key_base64: nil | String.t(),
          key_schema: nil | binary(),
          phrase: nil | binary()
        }

  def new(key_schema \\ "ed25519") do
    {:ok, {_, secret, _, phrase}} = :sui_nif.new(%{:key_schema => key_schema})
    ac = from(secret)
    ac = %{ac | key_schema: key_schema}
    {:ok, %{ac | phrase: phrase}}
  end

  def from(secret) do
    {:ok, {bin_public, public, bin_secret, secret}} = :sui_nif.account_detail(secret)

    %__MODULE__{
      priv_key_base64: secret,
      priv_key: bin_secret,
      sui_address: bin_public,
      sui_address_hex: public
    }
  end
end
