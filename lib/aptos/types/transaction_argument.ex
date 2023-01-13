defmodule Web3MoveEx.Aptos.Types.TransactionArgument do
  @moduledoc false

  use Bcs.TaggedEnum, [
    {:u8, :u8},
    {:u64, :u64},
    {:u128, :u128},
    {:address, Web3MoveEx.Aptos.Types.account_address()},
    {{:vector, :u8}, [:u8]},
    {:bool, :bool}
  ]
end
