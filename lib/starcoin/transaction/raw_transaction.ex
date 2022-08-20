defmodule Web3MoveEx.Starcoin.Transaction.RawTransaction do
  @moduledoc """
  In order to sign transaction offline, we need to encode RawTransaction in bcs format.
  """

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
