defmodule Web3MoveEx.Sui.Bcs.SuiAddress do
  @moduledoc false

@derive {Bcs.Struct,
      [
        val: [:u8 | 32]
      ]}
 defstruct [
    :val
 ]
end
