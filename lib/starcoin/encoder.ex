defmodule Web3SuiEx.Starcoin.Encoder do
  @moduledoc """
  Encoder args
  """

  alias Web3SuiEx.Starcoin.Address

  def encode(values, [:signer | rest]) do
    encode(values, rest)
  end

  def encode(values, types) do
    encode(values, types, [])
  end

  def encode([value | rest_values], [type | rest_types], acc) do
    {:ok, encoded} = encode_arg(value, type)
    encode(rest_values, rest_types, [encoded | acc])
  end

  def encode([], [], acc) do
    Enum.reverse(acc)
  end

  defp encode_arg(address, :address) do
    {:ok, address} = Address.new(address)
    {:ok, Bcs.encode(address)}
  end

  defp encode_arg(bool, :bool) do
    {:ok, Bcs.encode(bool, :bool)}
  end

  for n <- [8, 64, 128] do
    t = :"u#{n}"

    defp encode_arg(uint, unquote(t)) do
      {:ok, <<uint::little-unsigned-size(unquote(n))>>}
    end
  end

  defp encode_arg(list, {:vector, inner_type}) do
    Bcs.encode(list, unwrap_vector_type({:vector, inner_type}))
  end

  defp unwrap_vector_type({:vector, inner_type}) do
    [unwrap_vector_type(inner_type)]
  end

  defp unwrap_vector_type(type) do
    type
  end
end
