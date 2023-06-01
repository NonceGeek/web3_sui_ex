defmodule Web3SuiEx.Sui.Bcs.ObjectRef do
  alias Web3SuiEx.Sui.Bcs.Builder

  @derive {Bcs.Struct,
           [
             ref: Builder.object_ref()
           ]}
  defstruct [
    :ref
  ]
end
