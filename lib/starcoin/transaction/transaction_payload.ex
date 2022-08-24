defmodule Web3MoveEx.Starcoin.Transaction.TransactionPayload do
  @moduledoc false
  alias __MODULE__.{ScriptFunction}

  use Bcs.TaggedEnum,
    script: nil,
    package: nil,
    script_function: ScriptFunction

  defmodule ScriptFunction do
    @moduledoc false
    alias Web3MoveEx.Starcoin.Transaction.TypeTag

    @derive {Bcs.Struct,
             [
               address: [:u8 | 16],
               module: :string,
               function: :string,
               type_args: [TypeTag],
               args: [[:u8]]
             ]}
    defstruct [
      :address,
      :module,
      :function,
      :type_args,
      :args
    ]
  end
end
