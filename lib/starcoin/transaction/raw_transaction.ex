defmodule Web3MoveEx.Starcoin.Transaction.RawTransaction do
  @moduledoc """
  In order to sign transaction offline, we need to encode RawTransaction in bcs format.
  """

  alias Web3MoveEx.Starcoin.Transaction.TransactionPayload

  @derive {Bcs.Struct,
           [
             sender: [:u8 | 16],
             sequence_number: :u64,
             payload: TransactionPayload,
             max_gas_amount: :u64,
             gas_unit_price: :u64,
             gas_token_code: :string,
             expiration_timestamp_secs: :u64,
             chain_id: :u8
           ]}

  defstruct [
    :sender,
    :sequence_number,
    :payload,
    :max_gas_amount,
    :gas_unit_price,
    :gas_token_code,
    :expiration_timestamp_secs,
    :chain_id
  ]
end
