defmodule Web3SuiEx.Starcoin.Address do
  @moduledoc false

  @derive {Bcs.Struct, bytes: [:u8 | 16]}
  defstruct [:bytes]

  import Web3SuiEx.Starcoin.Helpers, only: [normalize_address: 1]

  def new(address) do
    with {:ok, bytes} <- normalize_address(address) do
      {:ok, %__MODULE__{bytes: bytes}}
    end
  end
end
