defmodule Web3SuiEx.Sui.Bcs.ObjectArg do
  @moduledoc false
  alias Web3SuiEx.Sui.Bcs.ShareObject
  import Web3SuiEx.Sui.Bcs.Builder

  use Bcs.TaggedEnum,
    imm_or_owned_object: object_ref(),
    share_object: ShareObject
end
