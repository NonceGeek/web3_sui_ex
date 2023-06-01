defmodule Web3SuiEx.StarcoinTest do
  @moduledoc false

  use ExUnit.Case, async: true

  # test "submit txn" do
  # client = Web3SuiEx.Starcoin.Client.connect()

  # payload =
  #   Web3SuiEx.Starcoin.Transaction.Function.call(
  #     client,
  #     "0x1::TransferScripts::peer_to_peer_v2",
  #     ["0x1::STC::STC"],
  #     ["0x0000000000000000000000000a550c18", 1]
  #   )

  # options = [private_key: "0xdebb41434877520254a4551a80b78dcfdce9bc3d576b13b66c3b343d515c0a8b"]

  # Web3SuiEx.Starcoin.submit_txn(client, payload, options)
  # end
end
