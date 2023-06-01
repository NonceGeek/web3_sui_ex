defmodule Web3SuiEx.Starcoin.Caller.ContractTest do
  @moduledoc false

  use ExUnit.Case, async: true

  # doctest Web3SuiEx.Caller.Contract

  import Mox

  alias Web3SuiEx.Starcoin.Caller.Contract

  setup :verify_on_exit!

  setup_all do
    endpoint = Web3SuiEx.Constant.endpoint(:local)
    %{endpoint: endpoint}
  end

  test "get_code", %{endpoint: endpoint} do
    result =
      "0xa11ceb0b040000000d01001a021a44035ed10304af045a058905f10207fa07930f088d1710069d1792020aaf19640b931a020c951af30d0d8828180ea028020000000100020003000400050006000700080009000a000b000c000d060000000800000e0800000f080100010010060000110400001204000013080000140400001506000a0a040100010a4e0700060607010000045204010601070707000016000101040017020300001802040104001905040104001a020600001b03020104001c02010104001d07010104001e08010104001f020000002002000000210900000022020600002302060000240a01010400250b01010400260c01010400270d01010400280e010000290f0100002a10010104002b11010104002c11010104002d020600002e100e00002f10120000300206010400310206010400321306000033020600003414150000351601000036170101040037180101040038190101040039000100003a100f00003b0e0100003c120100003d1a0100003e1b0100003f021c000040131c0000411d0100004209020000430201010400441e01010400451f0101040046200101040047212201040048231500004924220104004a25220104004b26220104004c272201040a5c29040104035d1c1c00075e01060104095f01010006602b0601000a242c01010408611002000a62220101040a63012201040a4d012e010404643001010603651c1c000666352801000c67371c010003681c1c000469100100066a28380100046b10390106066c3b010100036d1c1c000c6e013d0100026f10010003701c1c000c713706010005720303000b732201010403741c1c0001750302000a47402201041428032837283928142a0828062820283b0e3b1211283c281b280e282d280f2815283e283f284028412f41324133430e43121a2844364712470e48334832482f222835283628490e49124b362f284e3633285028022853281628010c000105010a02010401060b030109000101040c050a0204030c05040106080602050b0a01090002070b030109000b0a01090002060c0b0a01090003050b0a0109000a0201080501080601060c0305040a02010808010608010106080501060502060c0a0203060c05040406080805040a0204060c05040a02020c0a02020608050a02010302060c0106060c050303030307060c05030a0203030306060c05030a02030302060c04010b0a0109000106080802070b0301090004020608080403060808040a0203060c040a0201090001060b0a01090001080e01060b0c01090002070b0a0109000b0a01090002070801080b01080b01080002070b0d010900090001070801010804010809020708010501070b0c010900010201060a0900010b0c010900010b0d01090003080505080602070b0c01090009000205070802010a09000501070801070b030109000b0a0109000403040307080102070b0a0109000401070b030109000205070b03010900074163636f756e740d41757468656e74696361746f720d436f7265416464726573736573064572726f7273054576656e740448617368064f7074696f6e03535443065369676e65720954696d657374616d7005546f6b656e0e5472616e73616374696f6e46656506566563746f7210416363657074546f6b656e4576656e740f4175746f416363657074546f6b656e0742616c616e63650c4465706f7369744576656e74154b6579526f746174696f6e4361706162696c697479105369676e65724361706162696c6974790f5369676e657244656c6567617465641257697468647261774361706162696c6974790d57697468647261774576656e740c6163636570745f746f6b656e1261757468656e7469636174696f6e5f6b65790762616c616e63650b62616c616e63655f666f721563616e5f6175746f5f6163636570745f746f6b656e0e6372656174655f6163636f756e741b6372656174655f6163636f756e745f776974685f61646472657373226372656174655f6163636f756e745f776974685f696e697469616c5f616d6f756e74256372656174655f6163636f756e745f776974685f696e697469616c5f616d6f756e745f7632166372656174655f67656e657369735f6163636f756e740d6372656174655f7369676e6572166372656174655f7369676e65725f776974685f6361702164656c6567617465645f6b65795f726f746174696f6e5f6361706162696c6974791d64656c6567617465645f77697468647261775f6361706162696c697479076465706f736974126465706f7369745f746f5f62616c616e63650f6465706f7369745f746f5f73656c66156465706f7369745f776974685f6d657461646174611f64657374726f795f6b65795f726f746174696f6e5f6361706162696c6974791264657374726f795f7369676e65725f6361700f646f5f6163636570745f746f6b656e1a656d69745f6163636f756e745f6465706f7369745f6576656e741b656d69745f6163636f756e745f77697468647261775f6576656e74096578697374735f61741f657874726163745f6b65795f726f746174696f6e5f6361706162696c6974791b657874726163745f77697468647261775f6361706162696c6974790f69735f6163636570745f746f6b656e1069735f616363657074735f746f6b656e1169735f64756d6d795f617574685f6b65791369735f7369676e65725f64656c6567617465641f6b65795f726f746174696f6e5f6361706162696c6974795f616464726573730c6d616b655f6163636f756e74087061795f66726f6d137061795f66726f6d5f6361706162696c69gg"

    Web3SuiEx.HTTP.Mox
    |> expect(:json_rpc, fn method, id ->
      %{method: method, jsonrpc: "2.0", id: id}
    end)
    |> expect(:post, fn _url, _json ->
      body = %{
        "id" => 1,
        "jsonrpc" => "2.0",
        "result" => result
      }

      {:ok, body}
    end)

    params = [
      "0x1::Account"
    ]

    {:ok, data} = Contract.get_code(endpoint, params)

    # TODO
  end

  # test "call_v2", %{endpoint: endpoint} do
  #   Web3SuiEx.HTTP.Mox
  #   |> expect(:json_rpc, fn method, id ->
  #     %{method: method, jsonrpc: "2.0", id: id}
  #   end)
  #   |> expect(:post, fn _url, _json ->
  #     body = %{
  #       "id" => 1,
  #       "jsonrpc" => "2.0",
  #       "result" => [
  #         true
  #       ]
  #     }

  #     {:ok, body}
  #   end)

  #   payload = %{
  #     "function_id" => "0xb987F1aB0D7879b2aB421b98f96eFb44::MerkleDistributor2::is_claimd",
  #     "type_args" => ["0x00000000000000000000000000000001::STC::STC"],
  #     "args" => [
  #       "0x7beb045f2dea2f7fe50ede88c3e19a72",
  #       1_629_190_460,
  #       "0xxxxxxxxxxxx",
  #       0
  #     ]
  #   }

  #   {:ok, result} = Contract.call_v2(endpoint, [payload])
  #   # TODO
  # end

  describe "resolve_function" do
    test "Return data when contract function is right", %{endpoint: endpoint} do
      Web3SuiEx.HTTP.Mox
      |> expect(:json_rpc, fn method, id ->
        %{method: method, jsonrpc: "2.0", id: id}
      end)
      |> expect(:post, fn _url, _json ->
        body = %{
          id: 1,
          jsonrpc: "2.0",
          result: %{
            args: [
              %{doc: "", name: "p0", type_tag: "Signer"},
              %{doc: "", name: "p1", type_tag: "Address"},
              %{doc: "", name: "p2", type_tag: "U128"}
            ],
            doc: "",
            module_name: %{
              address: "0x00000000000000000000000000000001",
              name: "TransferScripts"
            },
            name: "peer_to_peer_v2",
            returns: [],
            ty_args: [%{abilities: 4, name: "T0", phantom: false}]
          }
        }

        {:ok, body}
      end)

      {:ok, data} =
        Contract.resolve_function(endpoint, [
          "0x00000000000000000000000000000001::TransferScripts::peer_to_peer_v2"
        ])

      assert %{
               id: 1,
               jsonrpc: "2.0",
               result: %{
                 args: [
                   %{doc: "", name: "p0", type_tag: "Signer"},
                   %{doc: "", name: "p1", type_tag: "Address"},
                   %{doc: "", name: "p2", type_tag: "U128"}
                 ],
                 doc: "",
                 module_name: %{
                   address: "0x00000000000000000000000000000001",
                   name: "TransferScripts"
                 },
                 name: "peer_to_peer_v2",
                 returns: [],
                 ty_args: [%{abilities: 4, name: "T0", phantom: false}]
               }
             } = data
    end

    test "Return data when contract function is wrong", %{endpoint: endpoint} do
      Web3SuiEx.HTTP.Mox
      |> expect(:json_rpc, fn method, id ->
        %{method: method, jsonrpc: "2.0", id: id}
      end)
      |> expect(:post, fn _url, _json ->
        body = %{
          id: 1,
          jsonrpc: "2.0",
          error: %{
            code: -32601,
            message: "Method not found"
          }
        }

        {:ok, body}
      end)

      {:ok, data} =
        Contract.resolve_function(endpoint, [
          "0x00000000000000000000000000000001::TransferScripts::peer_to_peer_v404"
        ])

      assert not is_nil(data[:error])
    end
  end

  describe "dry_run_raw" do
    test "Return data when %{signed_data} is right", %{endpoint: _endpoint} do
      # TODO
      assert true
    end

    test "Return wrong data when %{signed_data} is wrong", %{endpoint: endpoint} do
      Web3SuiEx.HTTP.Mox
      |> expect(:json_rpc, fn method, id ->
        %{method: method, jsonrpc: "2.0", id: id}
      end)
      |> expect(:post, fn _url, _json ->
        body = %{error: %{code: -32602, message: "Invalid params"}, id: 1, jsonrpc: "2.0"}

        {:ok, body}
      end)

      {:ok, data} = Contract.dry_run_raw(endpoint, "0x500", "01111")
      assert not is_nil(data[:error])
    end
  end
end
