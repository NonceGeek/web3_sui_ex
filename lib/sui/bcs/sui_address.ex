defmodule Web3MoveEx.Sui.Bcs.SuiAddress do
  @moduledoc false

  @derive {Bcs.Struct,
           [
             val: Web3MoveEx.Sui.Bcs.Builder.sui_address()
           ]}
  defstruct [
    :val
  ]
end
