defmodule Web3MoveEx.Caller do
  def build_method(class, method), do: "#{class}.#{method}"
end
