defmodule Web3MoveEx.Starcoin.Account do
  @moduledoc false

  import Web3MoveEx.Starcoin.Helpers

  alias Web3MoveEx.Starcoin.Caller.Contract
  alias Web3MoveEx.Starcoin.SigningKey

  defstruct [
    :address,
    :address_hex,
    :signing_key,
    :public_key,
    sequence_number: 0
  ]

  def new(private_key, client) do
    with {:ok, account} <- from_private_key(private_key),
         {:ok, sequence_number} <- Contract.get_sequence_number(client, account.address_hex) do
      {:ok, %{account | sequence_number: sequence_number}}
    end
  end

  def from_private_key(private_key) do
    with {:ok, signing_key} <- SigningKey.new(private_key) do
      from_signing_key(signing_key)
    end
  end

  def from_signing_key(signing_key) do
    public_key = sha3_256(signing_key.public_key <> <<0>>)
    <<_start::binary-size(16), b_address::binary>> = public_key

    {:ok,
     %__MODULE__{
       address: b_address,
       address_hex: to_hex(b_address),
       signing_key: signing_key,
       public_key: public_key
     }}
  end
end
