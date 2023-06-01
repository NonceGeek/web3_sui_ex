defmodule Web3SuiEx.Sui.Bcs.Argument do
  @moduledoc false
  use Bcs.TaggedEnum, [
    :gas_coin,
    input: :u16,
    result: :u16,
    nested_result: {:u16, :u16}
  ]
end
