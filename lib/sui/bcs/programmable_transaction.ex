defmodule Web3SuiEx.Sui.Bcs.ProgrammableTransaction do
  @moduledoc false
  alias Web3SuiEx.Sui.Bcs.CallArg
  alias Web3SuiEx.Sui.Bcs.Command

  @derive {Bcs.Struct,
           [
             inputs: [CallArg],
             commands: [Command]
           ]}
  defstruct [
    :inputs,
    :commands
  ]
end
