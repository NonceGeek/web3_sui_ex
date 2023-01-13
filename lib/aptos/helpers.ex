defmodule Web3MoveEx.Aptos.Helpers do
  @moduledoc false

  @spec sha3_256(binary()) :: binary()
  def sha3_256(bytes) do
    :crypto.hash(:sha3_256, bytes)
  end

  @spec to_hex(binary()) :: String.t()
  @spec to_hex(binary(), atom()) :: String.t()
  def to_hex(bytes, format \\ nil) do
    case format do
      :bare ->
        Base.encode16(bytes, case: :lower)

      :address ->
        "0x" <> String.trim_leading(Base.encode16(bytes, case: :lower), "0")

      _ ->
        "0x" <> Base.encode16(bytes, case: :lower)
    end
  end

  @spec from_hex(String.t()) :: {:ok, binary()} | :error
  def from_hex("0x" <> bytes) do
    Base.decode16(bytes, case: :mixed)
  end

  def from_hex(bytes) do
    Base.decode16(bytes, case: :mixed)
  end

  @spec from_hex(String.t(), non_neg_integer()) :: {:ok, binary()} | :error
  def from_hex("0x" <> bytes, size) do
    case Integer.parse(bytes, 16) do
      {number, ""} -> {:ok, <<number::size*8>>}
      _ -> :error
    end
  end

  def from_hex(bytes, size) do
    case Integer.parse(bytes, 16) do
      {number, ""} -> {:ok, <<number::size*8>>}
      _ -> :error
    end
  end

  def ed25519_new() do
    :crypto.generate_key(:eddsa, :ed25519)
  end

  def ed25519_new(private_key) do
    :crypto.generate_key(:eddsa, :ed25519, private_key)
  end

  def ed25519_public_key(private_key) do
    {public_key, _} = ed25519_new(private_key)
    public_key
  end

  def ed25519_sign(message, private_key) do
    :crypto.sign(:eddsa, :none, message, [private_key, :ed25519])
  end

  @spec normalize_bytes(binary() | non_neg_integer(), non_neg_integer()) :: binary()
  @spec normalize_bytes(binary() | non_neg_integer(), non_neg_integer(), boolean()) :: binary()
  def normalize_bytes(input, size, fixed_length \\ true) do
    cond do
      is_binary(input) ->
        input_size = byte_size(input)

        cond do
          input_size == size ->
            {:ok, input}

          not fixed_length ->
            from_hex(input, size)

          input_size == size * 2 ->
            from_hex(input)

          input_size == size * 2 + 2 ->
            from_hex(input)

          true ->
            {:error, :bad_format}
        end

      is_integer(input) ->
        cond do
          input < 0 ->
            {:error, :negtive_integer}

          input >= Bitwise.bsl(1, size * 8) ->
            {:error, :integer_too_big}

          true ->
            bits = size * 8
            {:ok, <<input::size(bits)>>}
        end

      true ->
        {:error, :bad_type}
    end
  end

  def normalize_key(key) do
    normalize_bytes(key, 32)
  end

  def normalize_key!(key) do
    {:ok, normalized_key} = normalize_key(key)
    normalized_key
  end

  def normalize_address(address) do
    normalize_bytes(address, 32, false)
  end

  def normalize_address!(address) do
    {:ok, normalized_address} = normalize_address(address)
    normalized_address
  end
end
