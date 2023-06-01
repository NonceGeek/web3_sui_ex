defmodule Web3SuiEx.Starcoin.Parser do
  @moduledoc false

  # TODO: detected the space between the params:
  # ~A"0x1::coin::transfer<CoinType>(address, u64)"f
  import NimbleParsec

  defp to_address(str) do
    <<String.to_integer(str, 16)::128>>
  end

  defp to_struct_tag(fields) do
    struct(Web3SuiEx.Starcoin.Transaction.TypeTag.StructTag, fields)
  end

  space = ascii_string([?\s], min: 0) |> ignore()

  bool_type = string("bool") |> replace(:bool)
  u8_type = string("u8") |> replace(:u8)
  u64_type = string("u64") |> replace(:u64)
  u128_type = string("u128") |> replace(:u128)
  address_type = string("address") |> replace(:address)
  string_type = string("string") |> replace(:string)
  signer_type = ignore(optional(string("&"))) |> string("signer") |> replace(:signer)

  address =
    string("0x")
    |> ignore()
    |> ascii_string([?0..?9, ?a..?f, ?A..?F], min: 1, max: 40)
    |> map(:to_address)
    |> label("address: 0x[0-9a-fA-F]{1,40}")

  generic = fn t ->
    string("<")
    |> ignore()
    |> concat(parsec(t))
    |> repeat(space |> string(",") |> ignore() |> parsec(t))
    |> concat(space |> string(">") |> ignore())
    |> label("generic type")
  end

  vector_type = fn t ->
    string("vector")
    |> ignore()
    |> concat(generic.(t))
    |> unwrap_and_tag(:vector)
    |> label("vector<[type_tag]>")
  end

  separator =
    string("::")
    |> ignore()
    |> label("separator")

  identifier =
    ascii_char([?a..?z, ?A..?Z])
    |> ascii_string([?_, ?0..?9, ?a..?z, ?A..?Z], min: 0)
    |> reduce({IO, :iodata_to_binary, []})
    |> label("identifier: [a-zA-Z][_a-zA-Z0-9]*")

  struct_type =
    address
    |> unwrap_and_tag(:address)
    |> concat(separator)
    |> concat(identifier |> unwrap_and_tag(:module))
    |> concat(separator)
    |> concat(identifier |> unwrap_and_tag(:name))
    |> optional(generic.(:type_tag) |> tag(:type_args))
    |> reduce(:to_struct_tag)
    |> unwrap_and_tag(:struct)
    |> label("struct")

  basic_types =
    choice([
      bool_type,
      u8_type,
      u64_type,
      u128_type,
      address_type,
      signer_type,
      string_type
    ])

  defparsecp(
    :type_tag,
    space
    |> choice([
      basic_types,
      vector_type.(:type_tag),
      struct_type
    ])
  )

  def parse_type_tag(string) do
    with {:ok, [result], "", _, _, _} <- type_tag(string) do
      {:ok, result}
    end
  end
end
