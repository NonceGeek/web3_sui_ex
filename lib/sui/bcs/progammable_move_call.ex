defmodule Web3SuiEx.Sui.Bcs.ProgammableMoveCall do
  @moduledoc false
  alias Web3SuiEx.Sui.Bcs.TypeTag
  alias Web3SuiEx.Sui.Bcs.Argument
  import Web3SuiEx.Sui.Bcs.Builder

  @derive {Bcs.Struct,
           [
             package: object_id(),
             module: identifier(),
             function: identifier(),
             type_arguments: [TypeTag],
             arguments: [Argument]
           ]}
  defstruct [
    :package,
    :module,
    :function,
    :type_arguments,
    :arguments
  ]
end
