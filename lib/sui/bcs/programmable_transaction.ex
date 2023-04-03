defmodule Web3MoveEx.Sui.Bcs.ProgrammableTransaction do
  @moduledoc false
  alias Web3MoveEx.Sui.Bcs.CallArg
  alias Web3MoveEx.Sui.Bcs.Command

  @derive {Bcs.Struct,
           [
             inputs: {:vector, CallArg},
             commands: {:vector, Command}
           ]}
  defstruct [
    :inputs,
    :commands
  ]
end
