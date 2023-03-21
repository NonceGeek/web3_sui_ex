defmodule Web3MoveEx.Aptos.Account do
  @moduledoc false

  defstruct [
    :address,
    :auth_key,
    :signing_key,
    :priv_key,
    :priv_key_hex,
    :sequence_number
  ]

  @type t() :: %__MODULE__{
          address: binary(),
          auth_key: nil | binary(),
          signing_key: nil | map(),
          priv_key: nil | binary(),
          priv_key_hex: nil | String.t(),
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
    do_from_private_key(private_key, address)
  end
  def do_from_private_key(private_key, address) when is_integer(private_key) do
    with {:ok, signing_key} <- Web3MoveEx.Aptos.SigningKey.new(private_key) do
      {:ok, acct} = from_signing_key(signing_key, address)
      private_key_hex = "0x#{private_key |> Integer.to_string(16) |> String.downcase()}"
      {:ok,
        acct
        |> Map.put(:priv_key, private_key)
        |> Map.put(:priv_key_hex, private_key_hex)
      }
    end
  end

  def do_from_private_key(private_key, address) when is_binary(private_key) do
    first_bin = Binary.take(private_key, 2)
    priv =
      case first_bin do
        "0x" ->

            private_key
            |> Binary.drop(2)
            |> String.to_integer(16)

        _ ->
            private_key
            |> Base.encode16(case: :lower)
            |> String.to_integer(16)
      end

    do_from_private_key(priv, address)

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
