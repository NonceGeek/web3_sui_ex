defmodule Web3MoveEx.Aptos.Types do
  @moduledoc false

  # BCS types
  def ed25519_key(), do: [:u8 | 32]
  def ed25519_signature(), do: [:u8 | 64]

  def account_address(), do: [:u8 | 32]

  def strip_signers([{:ref, :signer} | rest]) do
    strip_signers(rest)
  end

  def strip_signers([:signer | rest]) do
    strip_signers(rest)
  end

  def strip_signers(rest) do
    rest
  end

  def encode(types, values) do
    encode(types, values, [])
  end

  defp encode([{:ref, type} | rest_types], values, acc) do
    encode([type | rest_types], values, acc)
  end

  defp encode([type | rest_types], [value | rest_values], acc) do
    {:ok, encoded} = encode_arg(value, type)
    encode(rest_types, rest_values, [encoded | acc])
  end

  defp encode([], [], acc) do
    Enum.reverse(acc)
  end

  def encode_arg(address, :address) do
    {:ok, address} = Web3MoveEx.Aptos.Types.Address.new(address)
    {:ok, Bcs.encode(address)}
  end

  def encode_arg(bool, :bool) do
    {:ok, Bcs.encode(bool, :bool)}
  end

  for n <- [8, 64, 128] do
    t = :"u#{n}"

    def encode_arg(uint, unquote(t)) do
      {:ok, <<uint::little-unsigned-size(unquote(n))>>}
    end
  end

  def encode_arg(list, {:vector, inner_type}) do
    {:ok, Bcs.encode(list, unwrap_vector_type({:vector, inner_type}))}
  end

  defp unwrap_vector_type({:vector, inner_type}) do
    [unwrap_vector_type(inner_type)]
  end

  defp unwrap_vector_type(type) do
    type
  end
end
