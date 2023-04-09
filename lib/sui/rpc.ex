defmodule Web3MoveEx.Sui.RPC do
  @moduledoc """
    Api Docs: https://docs.sui.io/sui-jsonrpc#sui_getObject
  """
  alias Web3MoveEx.Sui.Bcs.IntentMessage

  alias Utils.ExHttp
  require Logger

  defstruct [:endpoint, :client]

  @endpoint %{
    devnet: "https://fullnode.devnet.sui.io:443"
  }
  defmodule ExecuteTransactionRequestType do
    def wait_for_local_execution, do: "WaitForLocalExecution"
    def wait_for_effects_cert, do: "WaitForEffectsCert"
  end

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
    post(client, body)
  end

  def suix_getReferenceGasPrice(client) do
    {:ok, v} = client |> call("suix_getReferenceGasPrice", [])
    String.to_integer(v)
  end

  def sui_executeTransactionBlock(
        client,
        signer,
        %IntentMessage{intent: _intent, data: value} = intent_msg
      ) do
    bcs_bytes_to_sign = Bcs.encode(intent_msg)
    {:ok, signatures} = sign(signer, bcs_bytes_to_sign)
    tx_bytes = Bcs.encode(value, Web3MoveEx.Sui.Bcs.TransactionData)

    sui_executeTransactionBlock(
      client,
      :base64.encode(tx_bytes),
      signatures,
      ExecuteTransactionRequestType.wait_for_local_execution(),
      :default
    )
  end

  def sui_executeTransactionBlock(client, tx_bytes, signatures, request_type, options \\ :default) do
    Logger.debug(
      "tx_bytes = #{inspect(tx_bytes)}, signatures=#{inspect(signatures)}, request_type=#{request_type}"
    )

    call(client, "sui_executeTransactionBlock", [
      tx_bytes,
      signatures,
      transaction_option(options),
      request_type
    ])
  end

  def unsafe_moveCall(
        client,
        signer,
        package_object_id,
        module,
        function,
        type_arguments,
        arguments,
        gas,
        gas_budget
      ) do
    call(client, "unsafe_moveCall", [
      signer,
      package_object_id,
      module,
      function,
      type_arguments,
      arguments,
      gas,
      gas_budget
    ])
  end

  def unsafe_transferObject(client, signer, object_id, gas, gas_budget, recipient) do
    call(client, "unsafe_transferObject", [signer, object_id, gas, gas_budget, recipient])
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

  @spec sign(Web3MoveEx.Sui.Account, binary()) :: {:ok, list()} | :error
  def sign(%Web3MoveEx.Sui.Account{priv_key_base64: priv_key_base64} = account, tx_bytes) do
    :sui_nif.sign(tx_bytes, priv_key_base64)
  end

  defp post(client, body, options \\ [])

  defp post(nil, body, options) do
    {:ok, client} = connect()
    post(client, body, options)
  end

  defp post(%{client: client}, body, options) do
    with {:ok, %{body: resp_body}} <- Tesla.post(client, "", reset_req(body), options) do
      case resp_body do
        %{error: %{code: _, message: message}} -> {:error, message}
        %{result: res} -> {:ok, res}
      end
    else
      {:error, error} -> {:error, error}
    end
  end

  defp reset_req(body) when is_binary(body) do
    body
  end

  defp reset_req(body), do: Jason.encode!(body)
end
