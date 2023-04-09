defmodule Web3MoveEx.Sui.Bcs.ObjectRef do
  alias Web3MoveEx.Sui.Bcs.Builder

  @derive {Bcs.Struct,
           [
             ref: Builder.object_ref()
           ]}
  defstruct [
    :ref
  ]
end
