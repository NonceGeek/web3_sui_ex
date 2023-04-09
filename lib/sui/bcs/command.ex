defmodule Web3MoveEx.Sui.Bcs.Command do
  @moduledoc false
  alias Web3MoveEx.Sui.Bcs.ProgrammableMoveCall
  alias Web3MoveEx.Sui.Bcs.Argument
  alias Web3MoveEx.Sui.Bcs.TypeTag
  import Web3MoveEx.Sui.Bcs.Builder

  use Bcs.TaggedEnum,
    movecall: ProgrammableMoveCall,
    transfer_objects: {[Argument], Argument},
    split_coins: {Argument, [Argument]},
    merge_coins: {Argument, [Argument]},
    publish: {[:u8], [object_id()]},
    make_move_vec: {TypeTag, [Argument]},
    upgrade: {[[:u8]], [object_id()], object_id(), Argument}
end
