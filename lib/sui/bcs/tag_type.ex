defmodule Web3MoveEx.Sui.Bcs.TypeTag do
  @moduledoc false
  use Bcs.TaggedEnum, [
    :bool,
    :u8,
    :u64,
    :u128,
    :address,
    :signer,
    {:vector, __MODULE__.TypeTag},
    #        {:struct, StructTag},
    :u16,
    :u32,
    :u256
  ]
end
