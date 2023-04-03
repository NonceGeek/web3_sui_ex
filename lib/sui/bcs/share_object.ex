defmodule Web3MoveEx.Sui.Bcs.ShareObject do
  alias Web3MoveEx.Sui.Bcs.Builder

  @derive {Bcs.Struct,
           [
             id: Builder.object_id(),
             initial_shared_version: Builder.seq_number(),
             mutable: :bool
           ]}
  defstruct [
    :id,
    :initial_shared_version,
    :mutable
  ]
end
