defmodule Web3MoveEx.Starcoin.Caller do
  def build_method(class, method), do: "#{class}.#{method}"

  @doc """
  "0x1::Account::Balance<0x1::STC::STC>"
  """
  def build_namespace(addr, module_name), do: "#{addr}::#{module_name}"

  def build_namespace(addr, module_name, func_or_resource) when is_binary(module_name) do
    "#{addr}::#{module_name}::#{func_or_resource}"
  end

  def build_namespace(addr, module_names, func_or_resource) when is_list(module_names) do
    module_names
    |> Enum.reduce("#{addr}::", fn module_name, acc ->
      acc <> "#{module_name}::"
    end)
    |> Kernel.<>("#{func_or_resource}")
  end
end
