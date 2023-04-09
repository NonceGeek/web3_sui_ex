defmodule Web3MoveEx.Sui.Bcs.CallArg do
  @moduledoc false
  alias Web3MoveEx.Sui.Bcs.ObjectArg

  use Bcs.TaggedEnum,
    pure: [:u8],
    object: ObjectArg
end