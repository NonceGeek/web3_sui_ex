defmodule Web3MoveEx.Aptos.Types.RawTransaction do
  @moduledoc """
  In order to sign transaction offline, we need to encode RawTransaction
  in bcs format.
  """

  import Web3MoveEx.Aptos.Types
  alias Web3MoveEx.Aptos.Types.TransactionPayload

  @derive {Bcs.Struct,
           [
             sender: account_address(),
             sequence_number: :u64,
             payload: TransactionPayload,
             max_gas_amount: :u64,
             gas_unit_price: :u64,
             expiration_timestamp_secs: :u64,
             chain_id: :u8
           ]}

  defstruct [
    :sender,
    :sequence_number,
    :payload,
    :max_gas_amount,
    :gas_unit_price,
    :expiration_timestamp_secs,
    :chain_id
  ]
end
