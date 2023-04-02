defmodule Web3MoveEx.Sui.Bcs.SuiAddress do
  @moduledoc false

@derive {Bcs.Struct,
      [
        [:u8 | 20]
      ]}
end
