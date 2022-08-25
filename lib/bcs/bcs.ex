defmodule Bcs do
  @moduledoc """
  Documentation for `Bcs`.

  Copy from Kabie/bcs. Since there is no release yet, If `Kabie/bcs` repo is stable, switch to hex.pm.
  """

  def encode(%module{} = value) do
    Bcs.Encoder.encode(value, module)
  end

  defdelegate encode(value, type), to: Bcs.Encoder
end
