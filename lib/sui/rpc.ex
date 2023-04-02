defmodule Web3MoveEx.Sui.RPC do
  @moduledoc """
    Api Docs: https://docs.sui.io/sui-jsonrpc#sui_getObject
  """
  alias Utils.ExHttp

  defstruct [:endpoint, :client]

  @endpoint %{
    devnet: "https://fullnode.devnet.sui.io:443"
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
        {Tesla.Middleware.Headers, [{"content-type", "application/json"}]},
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
  def sui_executeTransactionBlock(client, tx_bytes, signatures, request_type, options \\ :default) do
    call(client, "sui_executeTransactionBlock", [tx_bytes, signatures, transaction_option(options), request_type])
  end

  def transaction_option(:default) do
    %{
      "showInput" => true,
      "showRawInput" => true,
      "showEffects" => true,
      "showEvents" => true,
      "showObjectChanges" => true,
      "showBalanceChanges" => true
    }
  end
  def transaction_option(options) do
     options
  end

  def build_body(:get_obj, object_id, :default) do
    options = %{
      "showType" => true,
      "showOwner" => true,
      "showPreviousTransaction" => true,
      "showDisplay" => false,
      "showContent" => true,
      "showBcs" => false,
      "showStorageRebate" => true
    }

    build_body(:get_obj, object_id, options)
  end

  def build_body(:get_obj, object_id, options) do
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

  def call(client \\ nil, method, params) do
    client
    |> post(
      Jason.encode!(%{
        :jsonrpc => "2.0",
        :id => :erlang.system_time(1000),
        :method => method,
        :params => params
      })
    )
  end

  defp post(client, body, options \\ [])

  defp post(nil, body, options) do
    {:ok, client} = connect()
    post(client, body, options)
  end

  defp post(%{client: client}, body, options) do
    with {:ok, %{body: resp_body}} <- Tesla.post(client, "", body, options) do
      case resp_body do
        %{error: %{code: _, message: message}} -> {:error, message}
        %{result: res} -> {:ok, res}
      end
    else
      {:error, error} -> {:error, error}
    end
  end
end
