defmodule Web3MoveEx.Starcoin.Transaction.RawTransactionTest do
  @moduledoc false

  use ExUnit.Case

  alias Web3MoveEx.Starcoin.Account
  alias Web3MoveEx.Starcoin.Transaction.{RawTransaction, TransactionPayload, TypeTag}

  setup_all do
    {:ok, from_address} = Account.from_private_key(0x1)
    {:ok, to_address} = Account.from_private_key(0x2)

    %{from_address: from_address, to_address: to_address}
  end

  test "signed data is correct", %{from_address: from_address, to_address: to_address} do
    encode_args = Web3MoveEx.Starcoin.Encoder.encode([to_address.address, 1], [:address, :u128])

    payload = %TransactionPayload.ScriptFunction{
      address: <<0x1::128>>,
      module: "TransferScripts",
      function: "peer_to_peer_v2",
      type_args: [
        {:struct,
         %TypeTag.StructTag{
           address: <<0x1::128>>,
           module: "STC",
           name: "STC",
           type_args: []
         }}
      ],
      args: encode_args
    }

    raw_tx = %RawTransaction{
      sender: from_address.address,
      sequence_number: 0,
      payload: {:script_function, payload},
      max_gas_amount: 10_000_000,
      gas_unit_price: 1,
      gas_token_code: "0x1::STC::STC",
      expiration_timestamp_secs: 43319,
      chain_id: 254
    }

    signed_msg = """
    0x\
    ed26b6df208a9b569e5baf2590eb9b16\
    0000000000000000\
    02\
    00000000000000000000000000000001\
    0f5472616e7366657253637269707473\
    0f706565725f746f5f706565725f7632\
    0107\
    00000000000000000000000000000001\
    03535443\
    03535443\
    0002104afc3e2850563c65443111736b6be87b1001000000000000000000000000000000\
    8096980000000000\
    0100000000000000\
    0d3078313a3a5354433a3a535443\
    37a9000000000000\
    fe\
    """

    assert signed_msg == Web3MoveEx.Starcoin.Transaction.signing_message(raw_tx)
  end
end
