defmodule Web3MoveEx.Starcoin.Helpers do
  @moduledoc """
  Common helpers.
  """

  def sha3_256(bytes), do: :crypto.hash(:sha3_256, bytes)

  def normalize_bytes(input, size) do
    cond do
      is_binary(input) ->
        input_size = byte_size(input)

        cond do
          input_size == size ->
            {:ok, input}

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

  def from_hex("0x" <> bytes), do: from_hex(bytes)
  def from_hex(bytes), do: Base.decode16(bytes, case: :mixed)

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

  def normalize_address(address), do: normalize_bytes(address, 16)

  def normalize_key(key), do: normalize_bytes(key, 32)
end
