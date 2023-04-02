defmodule Web3MoveEx.Sui.Bcs.TransactionData do
  alias Web3MoveEx.Sui.Bcs.SuiAddress
  @moduledoc false
    @derive {Bcs.Struct,
           [
             kind: Web3MoveEx.Sui.Bcs.TransactionKind,
             sender: SuiAddress,
             gas_data: TransactionPayload
           ]}

  defstruct [
    :kind,
    :sender,
    :gas_data
  ]
end
