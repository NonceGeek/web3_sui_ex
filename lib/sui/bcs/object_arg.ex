defmodule Web3MoveEx.Sui.Bcs.ObjectArg do
  @moduledoc false
  alias Web3MoveEx.Sui.Bcs.TransactionKind.ShareObject
  import Web3MoveEx.Sui.Bcs.Builder

  use Bcs.TaggedEnum,
    imm_or_owned_object: object_ref,
    share_object: ShareObject
end
