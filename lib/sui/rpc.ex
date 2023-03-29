defmodule Web3MoveEx.Sui.RPC do
    @moduledoc """
      Api Docs: https://docs.sui.io/sui-jsonrpc#sui_getObject
    """
    alias Utils.ExHttp

    defstruct [:endpoint, :client, :chain_id]

    @endpoint %{
        devnet: "https://fullnode.devnet.sui.io:443"
      }

    @faucet %{
      testnet: "https://faucet.testnet.aptoslabs.com",
      devnet: "https://faucet.devnet.aptoslabs.com"
    }


    def connect() do
      connect(@endpoint.devnet)
    end

    def connect(:devnet) do
      connect(@endpoint.devnet)
    end

    def connect(endpoint) do
      client =
        Tesla.client([
          # TODO: convert input/output type
          {Tesla.Middleware.BaseUrl, endpoint},
          # {Tesla.Middleware.Headers, [{"content-type", "application/json"}]},
          {Tesla.Middleware.JSON, engine_opts: [keys: :atoms]}
        ])

      {:ok, %__MODULE__{client: client, endpoint: endpoint}}
    end

    def connect(:faucet, network_type) do
      endpoint = Map.get(@faucet, network_type)
      client =
        Tesla.client([
          {Tesla.Middleware.BaseUrl, endpoint},
          # {Tesla.Middleware.Headers, [{"content-type", "application/json"}]},
          {Tesla.Middleware.JSON, engine_opts: [keys: :atoms]}
        ])

      {:ok, %__MODULE__{client: client, endpoint: endpoint}}
    end

    def sui_get_object(client, object_id, options \\ :default) do
      body = build_body(:get_obj, object_id, options)
      post(client, "", body)
    end

    def build_body(:get_obj,object_id, :default) do
      options =
        %{
          "showType" => true,
          "showOwner" => true,
          "showPreviousTransaction" => true,
          "showDisplay" => false,
          "showContent" => true,
          "showBcs" => false,
          "showStorageRebate" => true
        }
      build_body(:get_obj,object_id, options)
    end
    def build_body(:get_obj,object_id, options) do
      %{
        jsonrpc: "2.0",
        method: "sui_getObject",
        params: [
          object_id,
          options
        ],
        id: 1
      }
    end

    def get_token_data(client, creator, collection_name, token_name) do
      with {:ok, result} <- get_resource(client, creator, "0x3::token::Collections") do
        %{handle: handle} = result.data.token_data

        token_data_id = %{
          creator: creator,
          collection: collection_name,
          name: token_name
        }

        table_key = %{
          key_type: "0x3::token::TokenDataId",
          value_type: "0x3::token::TokenData",
          key: token_data_id
        }

        get_table_item(client, handle, table_key)
      end
    end

    @doc """
      {:ok, client} = AptosRPC.connect()
      {:ok, res} =  Aptos.RPC.get_collection_data(
        client,
        "0xdc4e806913a006d86da8327a079d794435e2e3117fd418062ddf43943d663490",
        "DummyDog"
      )
    """
    def get_collection_data(client, account, collection_name) do
      with {:ok, result} <- get_resource(client, account, "0x3::token::Collections") do
        %{handle: handle} = result.data.collection_data

        table_key = %{
          key_type: "0x1::string::String",
          value_type: "0x3::token::CollectionData",
          key: collection_name
        }

        {:ok, result} = get_table_item(client, handle, table_key)

        case result do
          %{error_code: _} -> {:error, result}
          _ -> {:ok, result}
        end
      else
        _ -> {:error, "Token data not found"}
      end
    end

    defp get(%{client: client}, path, options \\ []) do
      with {:ok, %{status: 200, body: resp_body}} <- Tesla.get(client, path, options) do
        {:ok, resp_body}
      else
        {:ok, %{body: resp_body}} -> {:error, resp_body}
        {:error, error} -> {:error, error}
      end
    end

    defp post(%{client: client}, path, body, options \\ []) do
      with {:ok, %{body: resp_body}} <- Tesla.post(client, path, body, options) do
        case resp_body do
          %{code: _, message: message} -> {:error, message}
          _ -> {:ok, resp_body}
        end
      else
        {:error, error} -> {:error, error}
      end
    end

    # Chain
    def ledger_information(client) do
      get(client, "/")
    end

    # Accounts
    def get_account(client, address) do
      get(client, "/accounts/#{address}")
    end

    def get_resources(client, address, query \\ []) do
      get(client, "/accounts/#{address}/resources", query: query)
    end

    def get_resource(client, address, resource_type) do
      path = build_resource_path(client, address, resource_type)
      ExHttp.http_get(path)
    end

    def build_resource_path(%{endpoint: endpoint}, address, resource_type) do
      "#{endpoint}/accounts/#{address}/resource/#{resource_type}"
    end

    # Transactions
    def get_tx_by_hash(client, hash) do
      get(client, "/transactions/by_hash/#{hash}")
    end

    def check_tx_res_by_hash(client, hash, times \\ 3) do
      case get_tx_by_hash(client, hash) do
        {:ok, result} ->
          result.success

        {:error, _} ->
          if times > 0 do
            Process.sleep(1000)
            check_tx_res_by_hash(client, hash, times - 1)
          else
            false
          end
      end
    end

    # Events
    def get_events(client, event_key) do
      case get(client, "/events/#{event_key}") do
        {:ok, event_list} -> {:ok, event_list}
        {:error, %{error_code: "resource_not_found"}} -> {:ok, []}
      end
    end

    def get_events(client, address, event_handle, field, query \\ [limit: 10]) do
      case get(client, "/accounts/#{address}/events/#{event_handle}/#{field}", query: query) do
        {:ok, event_list} -> {:ok, event_list}
        {:error, %{error_code: "resource_not_found"}} -> {:ok, []}
      end
    end

    def build_event_path(%{endpoint: endpoint}, address, event_handle, field) do
      "#{endpoint}/accounts/#{address}/events/#{event_handle}/#{field}"
    end

    @doc """
    > https://fullnode.devnet.aptoslabs.com/v1/spec#/operations/get_table_item

    Example by curl:
    ```curl --request POST \
      --url https://fullnode.testnet.aptoslabs.com/v1/tables/0x55faf86aea81d23c0f8ec9bb5fa6ec8fed920a3482ea75d5bf27474a00d42198/item \
      --header 'Content-Type: application/json' \
      --data '{
      "key_type": "0x1::string::String",
      "value_type": "0xb923303d20c38a120669ad0ed751a105f254b049e75a350111d566009df9ba11::addr_info::AddrInfo",
      "key": "0x73c7448760517E3E6e416b2c130E3c6dB2026A1d"
    }'

    {"addr":"0x73c7448760517E3E6e416b2c130E3c6dB2026A1d","addr_type":"0","chains":["Ethereum"],"created_at":"1668826549","description":"Cool Addr","expired_at":"1700362549","id":"1","msg":"33344091.1.nonce_geek","pubkey":"","signature":"0x","updated_at":"0"}%
    ```

    Example to call by func:
    > Web3MoveEx.Aptos.RPC.get_table_item(client, "0x55faf86aea81d23c0f8ec9bb5fa6ec8fed920a3482ea75d5bf27474a00d42198", "0x1::string::String", "0xb923303d20c38a120669ad0ed751a105f254b049e75a350111d566009df9ba11::addr_info::AddrInfo", "0x73c7448760517E3E6e416b2c130E3c6dB2026A1d")
    """

    def get_table_item(client, table_handle, key_type, value_type, key) do
      payload = %{key_type: key_type, value_type: value_type, key: key}
      get_table_item(client, table_handle, payload)
    end

    def get_table_item(client, table_handle, table_key) do
      post(client, "/tables/#{table_handle}/item", table_key)
    end

    def submit_bcs_transaction(client, signed_transaction_in_bcs) do
      post(client, "/transactions", signed_transaction_in_bcs,
        headers: [{"content-type", "application/x.aptos.signed_transaction+bcs"}]
      )
    end

    def get_faucet(client, address, amount \\ 100000000) do
      post(client, "/mint?amount=#{amount}&address=#{address}", "")
    end
  end
