defmodule Web3SuiEx.Starcoin.Client do
  @moduledoc false

  alias Web3SuiEx.Starcoin.Caller.Chain

  defstruct [
    :endpoint,
    :chain_id
  ]

  @local Web3SuiEx.Constant.endpoint(:local)

  def connect(endpoint \\ @local) do
    with {:ok, %{result: result}} <- Chain.get_id(endpoint) do
      %__MODULE__{
        endpoint: endpoint,
        chain_id: result.id
      }
    end
  end
end
