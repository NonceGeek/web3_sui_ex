defmodule Bcs.Encoder do
  import Bitwise, only: [<<<: 2]

  @doc """
  Unsigned Little Endian Base 128.

  See https://en.wikipedia.org/wiki/LEB128#Unsigned_LEB128
  """
  def uleb128(value) when value >= 0 and value < unquote(1 <<< 7) do
    <<value::8>>
  end

  def uleb128(value) when value >= unquote(1 <<< 7) and value < unquote(1 <<< 14) do
    <<b1::7, b2::7>> = <<value::14>>
    <<1::1, b2::7, 0::1, b1::7>>
  end

  def uleb128(value) when value >= unquote(1 <<< 14) and value < unquote(1 <<< 21) do
    <<b1::7, b2::7, b3::7>> = <<value::21>>
    <<1::1, b3::7, 1::1, b2::7, 0::1, b1::7>>
  end

  def uleb128(value) when value >= unquote(1 <<< 21) and value < unquote(1 <<< 28) do
    <<b1::7, b2::7, b3::7, b4::7>> = <<value::28>>
    <<1::1, b4::7, 1::1, b3::7, 1::1, b2::7, 0::1, b1::7>>
  end

  def uleb128(value) when value >= unquote(1 <<< 28) and value < unquote(1 <<< 32) do
    <<b1::4, b2::7, b3::7, b4::7, b5::7>> = <<value::32>>
    <<1::1, b5::7, 1::1, b4::7, 1::1, b3::7, 1::1, b2::7, 0::1, b1::7>>
  end

  def uleb128(value) do
    raise ArgumentError, "Value too big for ULEB128 #{inspect(value)}"
  end

  @doc """
  Encode value to specific types.
  """
  def encode(value, type)

  def encode(true, :bool), do: <<0x01>>
  def encode(false, :bool), do: <<0x00>>

  for bit <- [8, 16, 32, 64, 128] do
    def encode(value, unquote(:"s#{bit}"))
        when value >= unquote(-(1 <<< (bit - 1))) and value < unquote(1 <<< (bit - 1)) do
      <<value::little-signed-unquote(bit)>>
    end

    def encode(value, unquote(:"u#{bit}")) when value >= 0 and value < unquote(1 <<< bit) do
      <<value::little-unsigned-unquote(bit)>>
    end
  end

  def encode(value, :string) when is_binary(value) do
    uleb128(byte_size(value)) <> value
  end

  def encode(value, [type | nil]) do
    if is_nil(value) do
      <<0x00>>
    else
      <<0x01>> <> encode(value, type)
    end
  end

  # special case for Vec<u8>
  def encode(value, [:u8 | size]) when is_binary(value) and byte_size(value) == size do
    value
  end

  def encode(value, [:u8]) when is_binary(value) do
    uleb128(byte_size(value)) <> value
  end

  def encode(value, [type | size]) when is_list(value) and length(value) == size do
    for inner_value <- value, into: <<>> do
      encode(inner_value, type)
    end
  end

  def encode(value, [type]) when is_list(value) do
    for inner_value <- value, into: uleb128(length(value)) do
      encode(inner_value, type)
    end
  end

  def encode(values, types)
      when is_tuple(values) and is_tuple(types) and tuple_size(values) == tuple_size(types) do
    encode_values(Tuple.to_list(values), Tuple.to_list(types))
  end

  def encode(value, type) when is_map(value) and is_map(type) and map_size(type) == 1 do
    [{k_type, v_type}] = Map.to_list(type)

    pairs =
      for {k, v} <- value do
        [encode(k, k_type), encode(v, v_type)]
      end
      |> Enum.sort()

    [uleb128(map_size(value)) | pairs]
    |> IO.iodata_to_binary()
  end

  def encode(value, type) when is_struct(value, type) do
    Bcs.Struct.encode(value)
  end

  def encode(value, type) when is_atom(type) do
    if {:module, type} == Code.ensure_loaded(type) && function_exported?(type, :encode, 1) do
      type.encode(value)
    else
      raise ArgumentError, "Can't encode #{inspect(value)} as #{inspect(type)}"
    end
  end

  def encode(value, type) do
    raise ArgumentError, "Can't encode #{inspect(value)} as #{inspect(type)}"
  end

  defp encode_values(values, types) do
    for {value, type} <- Enum.zip(values, types), into: <<>> do
      encode(value, type)
    end
  end
end
