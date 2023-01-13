defmodule Web3MoveEx.Aptos.Types.TypeTag do
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

  def to_string(type_tag) do
    case type_tag do
      {:vector, inner} -> "vector<#{inner}>"
      {:struct, inner} -> "#{inner}"
      others -> "#{others}"
    end
  end

  defmodule StructTag do
    @derive {Bcs.Struct,
             [
               address: Web3MoveEx.Aptos.Types.account_address(),
               module: :string,
               name: :string,
               type_args: [Web3MoveEx.Aptos.Types.TypeTag]
             ]}

    defstruct [
      :address,
      :module,
      :name,
      {:type_args, []}
    ]

    defimpl String.Chars do
      import Web3MoveEx.Aptos.Helpers, only: [to_hex: 2]

      def to_string(%{address: address, module: module, name: name, type_args: type_args}) do
        case type_args do
          [] ->
            "#{to_hex(address, :address)}::#{module}::#{name}"

          [_ | _] ->
            type_string =
              type_args
              |> Enum.map(&Web3MoveEx.Aptos.Types.TypeTag.to_string/1)
              |> Enum.join(",")

            "#{to_hex(address, :address)}::#{module}::#{name}<#{type_string}>"
        end
      end
    end

    defimpl Inspect do
      def inspect(struct_tag, _opts) do
        to_string(struct_tag)
      end
    end
  end
end
