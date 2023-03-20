defmodule Web3MoveEx.Aptos.Parser do
  @moduledoc false
  alias Web3MoveEx.Aptos.Types.Function
  import NimbleParsec

  defp to_address(str) do
    <<String.to_integer(str, 16)::256>>
  end

  defp to_struct_tag(fields) do
    struct(Web3MoveEx.Aptos.Types.TypeTag.StructTag, fields)
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
    |> ascii_string([?0..?9, ?a..?f, ?A..?F], min: 1, max: 64)
    |> map(:to_address)
    |> label("address: 0x[0-9a-fA-F]{1,64}")

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

  defparsecp(
    :primitive_types,
    choice([
      basic_types,
      vector_type.(:primitive_types)
    ])
    |> label("primitive types")
  )

  def parse_primitive_type(string) do
    with {:ok, [result], "", _, _, _} <- primitive_types(string) do
      {:ok, result}
    end
  end

  address_alias =
    ignore(string("@"))
    |> concat(identifier)
    |> map({String, :to_atom, []})

  params =
    string("(")
    |> ignore()
    |> concat(optional(parsec(:primitive_types)))
    |> repeat(space |> string(",") |> ignore() |> parsec(:primitive_types))
    |> concat(space |> string(")") |> ignore())
    |> label("function params")

  ability =
    choice([
      string("drop"),
      string("copy"),
      string("store"),
      string("key")
    ])

  defcombinatorp(
    :type_param,
    ignore(identifier)
    |> optional(
      ignore(string(":"))
      |> concat(ability)
      |> repeat(string(",") |> ignore() |> concat(ability))
    )
  )

  def to_type_params(constraints) do
    %{"constraints" => constraints}
  end

  defparsecp(
    :function,
    choice([
      address,
      address_alias
    ])
    |> unwrap_and_tag(:address)
    |> concat(separator)
    |> concat(identifier |> unwrap_and_tag(:module))
    |> concat(separator)
    |> concat(identifier |> unwrap_and_tag(:name))
    |> optional(
      generic.(:type_param)
      |> reduce(:to_type_params)
      |> tag(:type_params)
    )
    |> concat(params |> tag(:params))
    |> reduce(:to_function)
    |> label("function")
  )

  defp to_function(fields) do
    Function.new(fields)
    # struct(Web3MoveEx.Aptos.Types.Function, fields)
  end

  def parse_function(string) do
    with {:ok, [result], "", _, _, _} <- function(string) do
      {:ok, result}
    end
  end
end
