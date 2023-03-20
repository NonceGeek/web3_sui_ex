defmodule Web3MoveEx.Aptos.Types.Function do
  @moduledoc false

  defstruct address: nil,
            address_encoded: nil,
            module: nil,
            name: nil,
            type_params: [],
            params: [],
            param_names: [],
            return: [],
            visibility: :public,
            is_entry: true

  def new(fields) do
    %{address: address} =
      field_map =
        Enum.into(fields, %{})
    address_encoded = handle_addr(address)
    fields_handled = Map.put(field_map, :address_encoded, address_encoded)
    struct(__MODULE__, fields_handled)
  end

  @spec handle_addr(binary | integer) :: <<_::16, _::_*8>>
  def handle_addr(address) when is_binary(address) do
    "0x" <> (address |> Binary.trim_leading() |> Base.encode16(case: :lower))
  end

  def handle_addr(address) when is_integer(address) do
    "0x" <> (address |> Integer.to_string(16) |> String.downcase())
  end
end
