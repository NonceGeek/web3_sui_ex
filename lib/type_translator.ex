defmodule Web3MoveEx.TypeTranslator do
  def hex_to_starcoin_byte(hex_str) do
    "x\"#{hex_str}\""
  end
end
