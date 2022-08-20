defmodule Web3MoveEx.Starcoin.Transaction.RawTransactionTest do
  @moduledoc false

  use ExUnit.Case

  alias Web3MoveEx.Starcoin.Transaction.RawTransaction
  alias Web3MoveEx.Starcoin.Transaction.Payload

  test "signed data is correct" do
    # RawUserTransaction {
    #   sender: AccountAddress {
    #     value: [
    #       [Array], [Array], [Array],
    #       [Array], [Array], [Array],
    #       [Array], [Array], [Array],
    #       [Array], [Array], [Array],
    #       [Array], [Array], [Array],
    #       [Array]
    #     ]
    #   },
    #   sequence_number: 5n,
    #   payload: TransactionPayloadVariantScriptFunction {
    #     value: ScriptFunction {
    #       module: [ModuleId],
    #       func: [Identifier],
    #       ty_args: [Array],
    #       args: [Array]
    #     }
    #   },
    #   max_gas_amount: 10000000n,
    #   gas_unit_price: 1n,
    #   gas_token_code: '0x1::STC::STC',
    #   expiration_timestamp_secs: 43319n,
    #   chain_id: ChainId { id: 254 }
    # }

    # javascript_encode_msg = """
    # 0x
    # 52bfdf8638e3658bb9f00cc04ca98bdd
    # 0500000000000000
    #   02
    #   00000000000000000000000000000001
    #   0f5472616e7366657253637269707473
    #   0f706565725f746f5f706565725f7632
    #     0107
    #     00000000000000000000000000000001
    #     03535443
    #     03535443

    #   000210
    #   148347d07e8954c27bc6b76532f54eba
    #   10
    #   01000000000000000000000000000000
    # 8096980000000000\
    # 0100000000000000\
    # 0d3078313a3a5354433a3a535443\
    # 37a9000000000000\
    # fe
    # """
  end
end
