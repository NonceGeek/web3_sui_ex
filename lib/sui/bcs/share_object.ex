defmodule Web3SuiEx.Sui.Bcs.ShareObject do
  alias Web3SuiEx.Sui.Bcs.Builder

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
