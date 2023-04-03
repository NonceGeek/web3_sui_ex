defmodule Web3MoveEx.Sui.Bcs.Command do
  @moduledoc false
  alias Web3MoveEx.Sui.Bcs.ProgrammableMoveCall
  alias Web3MoveEx.Sui.Bcs.Argument
  alias Web3MoveEx.Sui.Bcs.TypeTag
  import Web3MoveEx.Sui.Bcs.Builder

  use Bcs.TaggedEnum,
    movecall: ProgrammableMoveCall,
    transfer_objects: {{:vector, Argument}, Argument},
    split_coins: {Argument, {:vector, Argument}},
    merge_coins: {Argument, {:vector, Argument}},
    publish: {{:vector, {:vector, :u8}}, {:vector, object_id}},
    make_move_vec: {TypeTag, {:vector, Argument}},
    upgrade: {{:vector, {:vector, :u8}}, {:vecotr, object_id}, object_id, Argument}
end
