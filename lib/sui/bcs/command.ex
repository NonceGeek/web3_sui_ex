defmodule Web3SuiEx.Sui.Bcs.Command do
  @moduledoc false
  alias Web3SuiEx.Sui.Bcs.ProgrammableMoveCall
  alias Web3SuiEx.Sui.Bcs.Argument
  alias Web3SuiEx.Sui.Bcs.TypeTag
  import Web3SuiEx.Sui.Bcs.Builder

  use Bcs.TaggedEnum,
    movecall: ProgrammableMoveCall,
    transfer_objects: {[Argument], Argument},
    split_coins: {Argument, [Argument]},
    merge_coins: {Argument, [Argument]},
    publish: {[:u8], [object_id()]},
    make_move_vec: {TypeTag, [Argument]},
    upgrade: {[[:u8]], [object_id()], object_id(), Argument}
end
