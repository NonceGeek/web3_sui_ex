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

  test "signed data with deploy contract", %{from_address: from_address} do
    {:ok, code} = File.read(Path.join([__DIR__, "fixtures/MyCounter.mv"]))

    script_function = %TransactionPayload.ScriptFunction{
      address: from_address.address,
      module: "MyCounter",
      function: "init_counter",
      type_args: [],
      args: []
    }

    code_module = %TransactionPayload.Package.Module{bytes: code}

    payload = %TransactionPayload.Package{
      address: from_address.address,
      modules: [code_module],
      init_script: script_function
    }

    raw_tx = %RawTransaction{
      sender: from_address.address,
      sequence_number: 0,
      payload: {:package, payload},
      max_gas_amount: 10_000_000,
      gas_unit_price: 1,
      gas_token_code: "0x1::STC::STC",
      expiration_timestamp_secs: 43319,
      chain_id: 254
    }

    signed_msg = """
    0x\
    ed26b6df208a9b569e5baf2590eb9b16
    0000000000000000
    01
    ed26b6df208a9b569e5baf2590eb9b1601f002a11ceb0b0400000009010004020404030823052b13073e6608a401200ac401050cc9017c0dc502020000010100020c00000300010000040201000005030100000604010000070001000008030100010a00060001060c0002060c03010c020c03010708000105094d79436f756e746572065369676e657207436f756e74657204696e637207696e63725f62790c696e63725f636f756e7465720f696e63725f636f756e7465725f627904696e69740c696e69745f636f756e7465720576616c75650a616464726573735f6f6652bfdf8638e3658bb9f00cc04ca98bdd0000000000000000000000000000000100020109030001000100050d0b0011062a000c010a01100014060100000000000000160b010f0015020101000100050d0b0011062a000c020a021000140a01160b020f001502020200010001030e00110002030200010001040e000a011101020401000001050b0006000000000000000012002d00020502000001030e0011040200000001ed26b6df208a9b569e5baf2590eb9b16094d79436f756e7465720c696e69745f636f756e7465720000
    8096980000000000
    0100000000000000
    0d3078313a3a5354433a3a535443
    37a9000000000000\
    fe\
    """

    assert signed_msg == Web3MoveEx.Starcoin.Transaction.signing_message(raw_tx)
  end
end
