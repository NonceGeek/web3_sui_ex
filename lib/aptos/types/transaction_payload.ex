defmodule Web3MoveEx.Aptos.Types.TransactionPayload do
  @moduledoc false

  alias Web3MoveEx.Aptos.Types.TransactionArgument
  alias __MODULE__.{Script, EntryFunction}

  use Bcs.TaggedEnum, [
    # Script(Script),
    script: Script,
    # ModuleBundle(ModuleBundle),
    module_bundle: nil,
    # EntryFunction(EntryFunction),
    entry_function: EntryFunction
  ]

  defmodule Script do
    alias Web3MoveEx.Aptos.Types.{TypeTag}

    @derive {Bcs.Struct,
             [
               code: [:u8],
               type_args: [TypeTag],
               args: [TransactionArgument]
             ]}

    defstruct [
      :code,
      :type_args,
      :args
    ]
  end

  defmodule EntryFunction do
    import Web3MoveEx.Aptos.Types
    alias Web3MoveEx.Aptos.Types.{TypeTag}

    # flatten ModuleId here to make the API simpler
    @derive {Bcs.Struct,
             [
               address: account_address(),
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
