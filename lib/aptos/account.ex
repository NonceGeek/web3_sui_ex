defmodule Web3MoveEx.Aptos.Account do
  @moduledoc false

  defstruct [
    :address,
    :auth_key,
    :signing_key,
    :sequence_number
  ]

  @type t() :: %__MODULE__{
          address: binary(),
          auth_key: nil | binary(),
          signing_key: nil | map(),
          sequence_number: nil | non_neg_integer()
        }

  import Web3MoveEx.Aptos.Helpers, only: [sha3_256: 1, to_hex: 2, normalize_address: 1]

  def from_address(address) do
    with {:ok, address} <- normalize_address(address) do
      {:ok, %__MODULE__{address: address}}
    end
  end

  def from_signing_key(signing_key, address \\ nil) do
    auth_key = sha3_256(signing_key.public_key <> <<0>>)

    with {:ok, address} <- normalize_address(address || auth_key) do
      {:ok,
       %__MODULE__{
         address: address,
         signing_key: signing_key,
         auth_key: auth_key
       }}
    end
  end

  def from_private_key(private_key, address \\ nil) do
    with {:ok, signing_key} <- Web3MoveEx.Aptos.SigningKey.new(private_key) do
      from_signing_key(signing_key, address)
    end
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%{address: address}, _opts) do
      concat(["#Account<", to_hex(address, :address), ">"])
    end
  end

  defimpl String.Chars do
    def to_string(%{address: address}) do
      to_hex(address, :address)
    end
  end
end
