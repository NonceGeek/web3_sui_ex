defmodule Web3MoveEx.Starcoin.Transaction.TransactionPayload do
  @moduledoc false
  alias __MODULE__.{Package, ScriptFunction}

  use Bcs.TaggedEnum,
    # A transaction that executes code.
    script: nil,
    # A transaction that publish or update module code by a package.
    package: Package,
    # A transaction that executes an existing script function published on-chain.
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

  defmodule Package do
    alias __MODULE__.Module

    @derive {Bcs.Struct,
             [
               address: [:u8 | 16],
               modules: [Module],
               init_script: [
                 Web3MoveEx.Starcoin.Transaction.TransactionPayload.ScriptFunction | nil
               ]
             ]}

    defstruct [
      :address,
      :modules,
      :init_script
    ]

    defmodule Module do
      @derive {Bcs.Struct, bytes: [:u8]}
      defstruct [:bytes]
    end
  end
end
