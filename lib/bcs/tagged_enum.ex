defmodule Bcs.TaggedEnum do
  @moduledoc false

  defmacro __using__(variants) do
    variants
    |> Enum.with_index(fn
      tagged, index ->
        tag = Bcs.Encoder.uleb128(index)

        case tagged do
          {variant_tag, type} ->
            quote do
              def encode({unquote(variant_tag), value}) do
                unquote(tag) <> Bcs.Encoder.encode(value, unquote(type))
              end
            end

          variant_tag ->
            quote do
              def encode(unquote(variant_tag)) do
                unquote(tag)
              end
            end
        end
    end)
  end
end
