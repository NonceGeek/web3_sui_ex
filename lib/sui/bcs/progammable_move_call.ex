defmodule Web3MoveEx.Sui.Bcs.ProgammableMoveCall do
  @moduledoc false
  alias Web3MoveEx.Sui.Bcs.TypeTag
  alias Web3MoveEx.Sui.Bcs.Argument
  import Web3MoveEx.Sui.Bcs.Builder

  @derive {Bcs.Struct,
           [
             package: object_id,
             module: identifier,
             function: identifier,
             type_arguments: {:vector, TypeTag},
             arguments: {:vector, Argument}
           ]}
  defstruct [
    :package,
    :module,
    :function,
    :type_arguments,
    :arguments
  ]
end
