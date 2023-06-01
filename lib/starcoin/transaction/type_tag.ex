defmodule Web3SuiEx.Starcoin.Transaction.TypeTag do
  @moduledoc false
  use Bcs.TaggedEnum, [
    :bool,
    :u8,
    :u64,
    :u128,
    :address,
    :signer,
    {:vector, __MODULE__},
    {:struct, __MODULE__.StructTag}
  ]

  defmodule StructTag do
    @moduledoc false

    @derive {Bcs.Struct,
             [
               address: [:u8 | 16],
               module: :string,
               name: :string,
               type_args: [Web3SuiEx.Starcoin.Transaction.TypeTag]
             ]}

    defstruct [
      :address,
      :module,
      :name,
      {:type_args, []}
    ]
  end
end
