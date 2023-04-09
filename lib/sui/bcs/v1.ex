defmodule Web3MoveEx.Sui.Bcs.V1 do
  @moduledoc false
  alias Web3MoveEx.Sui.Bcs.TransactionKind
  alias Web3MoveEx.Sui.Bcs.GasData
  alias Web3MoveEx.Sui.Bcs.TransactionData.TransactionExpire
  alias Web3MoveEx.Sui.Bcs.Builder

  @derive {Bcs.Struct,
           [
             kind: TransactionKind,
             sender: Builder.sui_address(),
             gas_data: GasData,
             expire: TransactionExpire
           ]}

  defstruct [
    :kind,
    :sender,
    :gas_data,
    :expire
  ]
end
