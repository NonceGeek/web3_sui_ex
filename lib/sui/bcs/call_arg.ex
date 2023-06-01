defmodule Web3SuiEx.Sui.Bcs.CallArg do
  @moduledoc false
  alias Web3SuiEx.Sui.Bcs.ObjectArg

  use Bcs.TaggedEnum,
    pure: [:u8],
    object: ObjectArg
end
