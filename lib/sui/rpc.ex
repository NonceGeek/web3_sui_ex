defmodule Web3MoveEx.Sui.RPC do

@endpoint "http://127.0.0.1:9000"

defstruct [:endpoint, :client]

def connect(endpoint \\ @endpoint) do
  client =
    Tesla.client([
      # TODO: convert input/output type
      {Tesla.Middleware.BaseUrl, endpoint},
      {Tesla.Middleware.Headers, [{"content-type", "application/json"}]},
      {Tesla.Middleware.JSON, engine_opts: [keys: :atoms]}
    ])

  {:ok, %__MODULE__{client: client, endpoint: endpoint}}
end
def call(client \\nil, method, params) do
  client |> post(Jason.encode!(%{
    :jsonrpc => "2.0",
    :id => :erlang.system_time(1000),
    :method => method,
    :params => params
    }))
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
