defmodule Web3SuiEx.Crypto do

  def generate_priv(:hex) do
    "0x#{Base.encode16(generate_priv(), case: :lower)}"
  end
  def generate_priv() do
    :crypto.strong_rand_bytes(32)
  end
end
