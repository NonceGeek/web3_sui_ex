defprotocol Bcs.Struct do
  @spec encode(value :: struct()) :: binary()
  def encode(value)
end

defimpl Bcs.Struct, for: Any do
  defmacro __deriving__(module, _struct, fields) do
    field_keys = Keyword.keys(fields)

    fields_encode_calls =
      fields
      |> Enum.map(fn {name, type} ->
        type = Macro.escape(type)

        quote do
          var!(value)
          |> Map.get(unquote(name))
          |> Bcs.Encoder.encode(unquote(type))
        end
      end)

    quote do
      @enforce_keys unquote(field_keys)

      defimpl Bcs.Struct, for: unquote(module) do
        def encode(var!(value)) do
          [unquote_splicing(fields_encode_calls)]
          |> IO.iodata_to_binary()
        end
      end
    end
  end

  def encode(_value) do
    throw(:not_implemented)
  end
end
