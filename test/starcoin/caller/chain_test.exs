defmodule Web3SuiEx.Starcoin.Caller.ChainTest do
  @moduledoc false

  use ExUnit.Case, async: true

  import Mox

  alias Web3SuiEx.Starcoin.Caller.Chain

  setup :verify_on_exit!

  setup_all do
    endpoint = Web3SuiEx.Constant.endpoint(:local)

    %{endpoint: endpoint}
  end

  test "get_id", %{endpoint: endpoint} do
    Web3SuiEx.HTTP.Mox
    |> expect(:json_rpc, fn method, id ->
      %{method: method, jsonrpc: "2.0", id: id}
    end)
    |> expect(:post, fn _url, _json ->
      body = %{"id" => 1, "jsonrpc" => "2.0", "result" => %{"id" => 254, "name" => "dev"}}
      {:ok, body}
    end)

    {:ok, result} = Chain.get_id(endpoint)

    assert %{"id" => 254, "name" => "dev"} = result["result"]
  end

  test "get_info", %{endpoint: endpoint} do
    Web3SuiEx.HTTP.Mox
    |> expect(:json_rpc, fn method, id ->
      %{method: method, jsonrpc: "2.0", id: id}
    end)
    |> expect(:post, fn _url, _json ->
      body = %{
        id: 100,
        jsonrpc: "2.0",
        result: %{
          block_info: %{
            block_accumulator_info: %{
              accumulator_root:
                "0x391d981028eaa01bf2b829fbc17ef58246eef1f1500f4e5a94a93c9c91a83976",
              frozen_subtree_roots: [
                "0xc9238f25bc37f4816baf254dfe207ca087a0b85dff0bce1e71f7f91ae80e3ba2",
                "0xeff938e00ffdaec25e6d304d09ea0a5fc771c8bf054d1ce6981886f30bcad57d",
                "0x5f62b4dcaa90f6dad98ce3ca0ff55a6fb6e5c4441f53e7f90596ce4ea428d29c"
              ],
              num_leaves: "14",
              num_nodes: "25"
            },
            block_hash: "0xe69a0e86744fadfef6da79f1b514680d3774b1626d18418b615add9ab14910b0",
            total_difficulty: "0x01fbd1",
            txn_accumulator_info: %{
              accumulator_root:
                "0x1f3f6f78a4aee6e97f1204aa5040326f1041ae96a65c5211f50cba04508da04a",
              frozen_subtree_roots: [
                "0x3c26842ff19ae5371cf69b612bbc69c840de9bfaddc72e0c263f3149eb1b8ee8",
                "0xf5d938b7cebe03995e38b89569f361594ac625af2da00701978f918ec0b6dd3e",
                "0x96059c83ac790978123122f1ae328a1b38512dc4a0ae3b4ba8792245489c26d1",
                "0x1e067b8a162c24f9d99c2bf54c456bc631e26df2e5e56489a73897ac30e4d820"
              ],
              num_leaves: "27",
              num_nodes: "50"
            }
          },
          chain_id: 254,
          genesis_hash: "0x155fff75365299de34f6c17a941936f4873ff6a6ce263a38d51cc49bcdd05002",
          head: %{
            author: "0x52bfdf8638e3658bb9f00cc04ca98bdd",
            author_auth_key: nil,
            block_accumulator_root:
              "0xff560662c2d63dad8f24003353f0f7f15c54ddb922836354c13a92d3ef37e30a",
            block_hash: "0xe69a0e86744fadfef6da79f1b514680d3774b1626d18418b615add9ab14910b0",
            body_hash: "0xc67d6a325353e17636c1445283e70bc1296d44ee87dc895dafca1f0941b54b7e",
            chain_id: 254,
            difficulty: "0x2710",
            extra: "0x00000000",
            gas_used: "105547",
            nonce: 11721,
            number: "13",
            parent_hash: "0xed5d1f09feec9ecbff93558595aa77c72fb0535b882d708890889696f2b76858",
            state_root: "0xbbfb6f41afc21049f3ef801e13ef990e4b1f1d64e15ef88075a6989a7d37e29d",
            timestamp: "119450",
            txn_accumulator_root:
              "0x1f3f6f78a4aee6e97f1204aa5040326f1041ae96a65c5211f50cba04508da04a"
          }
        }
      }

      {:ok, body}
    end)

    {:ok, result} = Chain.get_info(endpoint)
    assert not is_nil(result[:result][:block_info])
  end

  test "get_block_by_number", %{endpoint: endpoint} do
    Web3SuiEx.HTTP.Mox
    |> expect(:json_rpc, fn method, id ->
      %{method: method, jsonrpc: "2.0", id: id}
    end)
    |> expect(:post, fn _url, _json ->
      body = %{
        id: 1,
        jsonrpc: "2.0",
        result: %{
          body: %{
            Full: [
              %{
                authenticator: %{
                  MultiEd25519: %{
                    public_key:
                      "0xb9c6ee1630ef3e711144a648db06bbb2284f7274cfbee53ffcee503cc1a49200aef3f4a4b8eca1dfc343361bf8e436bd42de9259c04b8314eb8e2054dd6e82ab01",
                    signature:
                      "0x37d0113b658be6a1426d21676a2f80ed44c76d9574ef98424c78d651cdf5d15a650df34594a75db8791db0063d6121254eb9b13e747b990004dee6b37875100240000000"
                  }
                },
                raw_txn: %{
                  chain_id: 254,
                  expiration_timestamp_secs: "3614",
                  gas_token_code: "0x1::STC::STC",
                  gas_unit_price: "1",
                  max_gas_amount: "10000000",
                  payload:
                    "0x02000000000000000000000000000000010f5472616e73666572536372697074730f706565725f746f5f706565725f76320107000000000000000000000000000000010353544303535443000210148347d07e8954c27bc6b76532f54eba1000e87648170000000000000000000000",
                  sender: "0x0000000000000000000000000a550c18",
                  sequence_number: "1"
                },
                transaction_hash:
                  "0x4da994b90f6d9336954c15197332765f59297a4fc8fc24340f638510fb8f6585"
              }
            ]
          },
          header: %{
            author: "0x52bfdf8638e3658bb9f00cc04ca98bdd",
            author_auth_key: nil,
            block_accumulator_root:
              "0xad72d5fda032c7c4a6b5b06c15f14171ea7c510a59b3eb665d185e02547f116f",
            block_hash: "0x59024d3aa3c4b7e5faa02374787113e75dc19bfc545c4b1f02aee19bc9932da2",
            body_hash: "0x19c4ca23f7805b3f55053f3d7f6b712a4238817cb482dcab4b3e011b3b33ee84",
            chain_id: 254,
            difficulty: "0x2710",
            extra: "0x00000000",
            gas_used: "284531",
            nonce: 14672,
            number: "1",
            parent_hash: "0x58d71c77d8302dc9c6ae00f5c0e5fb63077c33ae4bd04b26097df4550e0f32cc",
            state_root: "0x6dfa95ae8a3a3bb0a3ccd3052064324ab2f99d395516dde5950fae03dcc8ea30",
            timestamp: "14897",
            txn_accumulator_root:
              "0xb0104563cb41a88bb59ef194af52820c5ef378252c3f683dfe2c06a3ff8611e4"
          },
          raw: nil,
          uncles: []
        }
      }

      {:ok, body}
    end)

    {:ok, result} = Chain.get_block_by_number(endpoint, 1)
    assert result[:result][:header][:number] == "1"
  end

  describe "Get Transaction" do
    test "return tx data if %{tx_hash} the is exists", %{endpoint: endpoint} do
      Web3SuiEx.HTTP.Mox
      |> expect(:json_rpc, fn method, id ->
        %{method: method, jsonrpc: "2.0", id: id}
      end)
      |> expect(:post, fn _url, _json ->
        body = %{
          id: 1,
          jsonrpc: "2.0",
          result: %{
            block_hash: "0xe69a0e86744fadfef6da79f1b514680d3774b1626d18418b615add9ab14910b0",
            block_metadata: nil,
            block_number: "13",
            transaction_hash:
              "0xa23138f12b9f8221227dfebda5001bef176f9fcc9ce0c3eab2928d0a342bc6f1",
            transaction_index: 1,
            user_transaction: %{
              raw_txn: %{},
              transaction_hash:
                "0xa23138f12b9f8221227dfebda5001bef176f9fcc9ce0c3eab2928d0a342bc6f1"
            }
          }
        }

        {:ok, body}
      end)

      tx_hash = "0xa23138f12b9f8221227dfebda5001bef176f9fcc9ce0c3eab2928d0a342bc6f1"

      {:ok, result} = Chain.get_transaction(endpoint, tx_hash)
      assert result[:result][:transaction_hash] == tx_hash
    end

    test "return error if %{tx_hash} is not exists", %{endpoint: endpoint} do
      Web3SuiEx.HTTP.Mox
      |> expect(:json_rpc, fn method, id ->
        %{method: method, jsonrpc: "2.0", id: id}
      end)
      |> expect(:post, fn _url, _json ->
        body = %{id: 1, jsonrpc: "2.0", result: nil}
        {:ok, body}
      end)

      tx_hash = "0x404"

      {:ok, result} = Chain.get_transaction(endpoint, tx_hash)
      assert is_nil(result[:result])
    end
  end

  describe "Get Transaction Info" do
    test "return tx data if the %{tx_hash} is exists", %{endpoint: endpoint} do
      Web3SuiEx.HTTP.Mox
      |> expect(:json_rpc, fn method, id ->
        %{method: method, jsonrpc: "2.0", id: id}
      end)
      |> expect(:post, fn _url, _json ->
        body = %{
          id: 1,
          jsonrpc: "2.0",
          result: %{
            block_hash: "0xe69a0e86744fadfef6da79f1b514680d3774b1626d18418b615add9ab14910b0",
            block_number: "13",
            event_root_hash: "0x2a923baa8a00e3dec5a4c7287b4d9827c0813d80376f43bbc6567038a396bcc9",
            gas_used: "105547",
            state_root_hash: "0xbbfb6f41afc21049f3ef801e13ef990e4b1f1d64e15ef88075a6989a7d37e29d",
            status: "Executed",
            transaction_global_index: "26",
            transaction_hash:
              "0xa23138f12b9f8221227dfebda5001bef176f9fcc9ce0c3eab2928d0a342bc6f1",
            transaction_index: 1
          }
        }

        {:ok, body}
      end)

      tx_hash = "0xa23138f12b9f8221227dfebda5001bef176f9fcc9ce0c3eab2928d0a342bc6f1"
      {:ok, result} = Chain.get_transaction_info(endpoint, tx_hash)

      assert result[:result][:transaction_hash] == tx_hash
      assert result[:result][:status] == "Executed"
    end

    test "return nil if the %{tx_hash} is not exists", %{endpoint: endpoint} do
      Web3SuiEx.HTTP.Mox
      |> expect(:json_rpc, fn method, id ->
        %{method: method, jsonrpc: "2.0", id: id}
      end)
      |> expect(:post, fn _url, _json ->
        body = %{id: 1, jsonrpc: "2.0", result: nil}
        {:ok, body}
      end)

      tx_hash = "0x404"

      {:ok, result} = Chain.get_transaction_info(endpoint, tx_hash)
      assert is_nil(result[:result])
    end
  end
end
