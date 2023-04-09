defmodule Web3MoveEx.Sui.Bcs.IntentMessage do
  alias __MODULE__.Intent
  @moduledoc false
  @derive {Bcs.Struct,
           [
             intent: Intent,
             data: Web3MoveEx.Sui.Bcs.TransactionData
           ]}
  defstruct [
    :intent,
    :data
  ]

  defmodule Intent do
    @derive {Bcs.Struct,
             [
               scope: :u8,
               version: :u8,
               app_id: :u8
             ]}
    defstruct [
      :scope,
      :version,
      :app_id
    ]

    def default(), do: %Intent{scope: 0, version: 0, app_id: 0}
  end
end
