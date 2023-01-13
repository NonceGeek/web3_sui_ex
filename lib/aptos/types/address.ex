defmodule Web3MoveEx.Aptos.Types.Address do
  @moduledoc false

  @derive {Bcs.Struct, bytes: [:u8 | 32]}
  defstruct [:bytes]

  import Web3MoveEx.Aptos.Helpers, only: [normalize_address: 1, to_hex: 2]

  def new(address) do
    with {:ok, bytes} <- normalize_address(address) do
      {:ok, %__MODULE__{bytes: bytes}}
    end
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%{bytes: bytes}, _opts) do
      concat(["~A<", to_hex(bytes, :address), ">a"])
    end
  end

  defimpl String.Chars do
    def to_string(%{bytes: bytes}) do
      to_hex(bytes, :address)
    end
  end
end
