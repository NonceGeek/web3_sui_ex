defmodule Web3MoveEx.Sui.Bcs.TypeTag do
  @moduledoc false
  use Bcs.TaggedEnum, [
    :bool,
    :u8,
    :u64,
    :u128,
    :address,
    :signer,
    {:vector, [__MODULE__.TypeTag]},
    {:struct, __MODULE__.StructTag},
    :u16,
    :u32,
    :u256
  ]

  defmodule StructTag do
    @derive {Bcs.Struct,
             [
               address: Web3MoveEx.Sui.Bcs.Builder.sui_address(),
               module: :string,
               name: :string,
               type_params: [Web3MoveEx.Sui.Bcs.TypeTag]
             ]}

    defstruct [
      :address,
      :module,
      :name,
      {:type_params, []}
    ]
  end
end
