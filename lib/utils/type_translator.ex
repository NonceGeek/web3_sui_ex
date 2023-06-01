defmodule Web3SuiEx.TypeTranslator do
  @moduledoc false

  def hex_to_starcoin_byte(hex_str) do
    "x\"#{hex_str}\""
  end

  def parse_type_in_move(%{U64: value}) do
    String.to_integer(value)
  end

  def parse_type_in_move(%{Bytes: bytes}) do
    bytes
    |> Binary.drop(2)
    |> Base.decode16!(case: :lower)
  end

  # TODO: impl other types
end
