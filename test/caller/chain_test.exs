defmodule Web3MoveEx.Caller.ChainTest do
  @moduledoc false

  use ExUnit.Case, async: true

  doctest Web3MoveEx.Starcoin.Caller.Chain

  import Mox

  setup :verify_on_exit!

  test "get_id" do
    Web3MoveEx.HTTP.Mox
    |> expect(:json_rpc, fn method, id ->
      %{method: method, jsonrpc: "2.0", id: id}
    end)
    |> expect(:post, fn _url, _json ->
      body = %{"id" => 1, "jsonrpc" => "2.0", "result" => %{"id" => 254, "name" => "dev"}}
      {:ok, body}
    end)

    endpoint = Web3MoveEx.Constant.endpoint(:local)
    {:ok, result} = Web3MoveEx.Caller.Chain.get_id(endpoint, 1)

    assert 1 = result["id"]
    assert %{"id" => 254, "name" => "dev"} = result["result"]
  end

  test "get_info" do
    Web3MoveEx.HTTP.Mox
    |> expect(:json_rpc, fn method, id ->
      %{method: method, jsonrpc: "2.0", id: id}
    end)
    |> expect(:post, fn _url, _json ->
      body = %{
        "id" => 1,
        "jsonrpc" => "2.0",
        "result" => %{
          "block_info" => %{
            "block_accumulator_info" => %{
              "accumulator_root" =>
                "0xc9238f25bc37f4816baf254dfe207ca087a0b85dff0bce1e71f7f91ae80e3ba2",
              "frozen_subtree_roots" => [
                "0xc9238f25bc37f4816baf254dfe207ca087a0b85dff0bce1e71f7f91ae80e3ba2"
              ],
              "num_leaves" => "8",
              "num_nodes" => "15"
            },
            "block_hash" => "0xace41a275056745947fc461a1afb88056c26c781ee57b3fa4132ae4ff9891084",
            "total_difficulty" => "0x011171",
            "txn_accumulator_info" => %{
              "accumulator_root" =>
                "0x0993ccf6b8df38164dd5359d88e2c871f0c30ce820ad92cef6f8b6a1b8eabe5b",
              "frozen_subtree_roots" => [
                "0xc564bef4b7317fcbed857f9f0b84140705cd1e99cb4d6045311a1ea0fd9dad88",
                "0x55524504d73967dd46fd4fa68076a4858d13f0df2f10afb57f97184a755dc97a",
                "0x5385189bca08f6fe1aed602e1241d148f7f1704e2306bbb01a9b1af82815b01b",
                "0xa6077f09fd6e9f91196f93c127d7c172887e3d516585881182f2dfda50fa6920"
              ],
              "num_leaves" => "15",
              "num_nodes" => "26"
            }
          },
          "chain_id" => 254,
          "genesis_hash" => "0x155fff75365299de34f6c17a941936f4873ff6a6ce263a38d51cc49bcdd05002",
          "head" => %{
            "author" => "0x52bfdf8638e3658bb9f00cc04ca98bdd",
            "author_auth_key" => nil,
            "block_accumulator_root" =>
              "0x604d62a86aa6bd0e6c98ee97e4b67e536e133b3451b225fc37312b3feadf120e",
            "block_hash" => "0xace41a275056745947fc461a1afb88056c26c781ee57b3fa4132ae4ff9891084",
            "body_hash" => "0x8b3ac63a1bd078f54a286595c3d4620b7d3a98b49350be125d80249b82030e64",
            "chain_id" => 254,
            "difficulty" => "0x2710",
            "extra" => "0x00000000",
            "gas_used" => "17231",
            "nonce" => 8268,
            "number" => "7",
            "parent_hash" => "0xd9577742a57b36d06cc2ef473d0d1e0118247347796d5b7619df276cb906bb58",
            "state_root" => "0x1d9f90df39d0fb9cf329f06698208f8721800c29a063751e4108b8ee76a9860d",
            "timestamp" => "71686",
            "txn_accumulator_root" =>
              "0x0993ccf6b8df38164dd5359d88e2c871f0c30ce820ad92cef6f8b6a1b8eabe5b"
          }
        }
      }

      {:ok, body}
    end)

    endpoint = Web3MoveEx.Constant.endpoint(:local)
    {:ok, result} = Web3MoveEx.Caller.Chain.get_info(endpoint, 1)
    # TODO
  end

  test "get_block_by_number" do
    Web3MoveEx.HTTP.Mox
    |> expect(:json_rpc, fn method, id ->
      %{method: method, jsonrpc: "2.0", id: id}
    end)
    |> expect(:post, fn _url, _json ->
      body = %{
        "id" => 1,
        "jsonrpc" => "2.0",
        "result" => %{
          "block_info" => %{
            "block_accumulator_info" => %{
              "accumulator_root" =>
                "0xc9238f25bc37f4816baf254dfe207ca087a0b85dff0bce1e71f7f91ae80e3ba2",
              "frozen_subtree_roots" => [
                "0xc9238f25bc37f4816baf254dfe207ca087a0b85dff0bce1e71f7f91ae80e3ba2"
              ],
              "num_leaves" => "8",
              "num_nodes" => "15"
            },
            "block_hash" => "0xace41a275056745947fc461a1afb88056c26c781ee57b3fa4132ae4ff9891084",
            "total_difficulty" => "0x011171",
            "txn_accumulator_info" => %{
              "accumulator_root" =>
                "0x0993ccf6b8df38164dd5359d88e2c871f0c30ce820ad92cef6f8b6a1b8eabe5b",
              "frozen_subtree_roots" => [
                "0xc564bef4b7317fcbed857f9f0b84140705cd1e99cb4d6045311a1ea0fd9dad88",
                "0x55524504d73967dd46fd4fa68076a4858d13f0df2f10afb57f97184a755dc97a",
                "0x5385189bca08f6fe1aed602e1241d148f7f1704e2306bbb01a9b1af82815b01b",
                "0xa6077f09fd6e9f91196f93c127d7c172887e3d516585881182f2dfda50fa6920"
              ],
              "num_leaves" => "15",
              "num_nodes" => "26"
            }
          },
          "chain_id" => 254,
          "genesis_hash" => "0x155fff75365299de34f6c17a941936f4873ff6a6ce263a38d51cc49bcdd05002",
          "head" => %{
            "author" => "0x52bfdf8638e3658bb9f00cc04ca98bdd",
            "author_auth_key" => nil,
            "block_accumulator_root" =>
              "0x604d62a86aa6bd0e6c98ee97e4b67e536e133b3451b225fc37312b3feadf120e",
            "block_hash" => "0xace41a275056745947fc461a1afb88056c26c781ee57b3fa4132ae4ff9891084",
            "body_hash" => "0x8b3ac63a1bd078f54a286595c3d4620b7d3a98b49350be125d80249b82030e64",
            "chain_id" => 254,
            "difficulty" => "0x2710",
            "extra" => "0x00000000",
            "gas_used" => "17231",
            "nonce" => 8268,
            "number" => "7",
            "parent_hash" => "0xd9577742a57b36d06cc2ef473d0d1e0118247347796d5b7619df276cb906bb58",
            "state_root" => "0x1d9f90df39d0fb9cf329f06698208f8721800c29a063751e4108b8ee76a9860d",
            "timestamp" => "71686",
            "txn_accumulator_root" =>
              "0x0993ccf6b8df38164dd5359d88e2c871f0c30ce820ad92cef6f8b6a1b8eabe5b"
          }
        }
      }

      {:ok, body}
    end)

    endpoint = Web3MoveEx.Constant.endpoint(:local)
    {:ok, result} = Web3MoveEx.Caller.Chain.get_block_by_number(endpoint, 1)
    # TODO
  end
end
