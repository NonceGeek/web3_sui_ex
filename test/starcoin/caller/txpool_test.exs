defmodule Web3SuiEx.Starcoin.Caller.TxpoolTest do
  @moduledoc false

  use ExUnit.Case, async: true

  import Mox

  alias Web3SuiEx.Starcoin.Caller.Txpool

  setup :verify_on_exit!

  setup_all do
    endpoint = Web3SuiEx.Constant.endpoint(:local)
    %{endpoint: endpoint}
  end

  describe "submit_hex_transaction" do
    test "Should be right when %{singed_data} is right", %{endpoint: endpoint} do
      Web3SuiEx.HTTP.Mox
      |> expect(:json_rpc, fn method, id ->
        %{method: method, jsonrpc: "2.0", id: id}
      end)
      |> expect(:post, fn _url, _json ->
        body = %{
          id: 200,
          jsonrpc: "2.0",
          result: "0x200"
        }

        {:ok, body}
      end)

      {:ok, data} = Txpool.submit_hex_transaction(endpoint, "0x200")
      assert not is_nil(data[:result])
    end

    test "Return error when %{signed_data} is wrong", %{endpoint: endpoint} do
      Web3SuiEx.HTTP.Mox
      |> expect(:json_rpc, fn method, id ->
        %{method: method, jsonrpc: "2.0", id: id}
      end)
      |> expect(:post, fn _url, _json ->
        body = %{
          jsonrpc: "2.0",
          id: 200,
          error: %{code: "49998", message: "Invalid transaction"}
        }

        {:ok, body}
      end)

      {:ok, data} = Txpool.submit_hex_transaction(endpoint, "0x500")
      assert not is_nil(data[:error])
    end
  end
end
