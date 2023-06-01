defmodule Web3SuiEx.Sui.Bcs.SuiAddress do
  @moduledoc false

  @derive {Bcs.Struct,
           [
             val: Web3SuiEx.Sui.Bcs.Builder.sui_address()
           ]}
  defstruct [
    :val
  ]
end
