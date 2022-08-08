defmodule Web3MoveEx.Caller do
  def build_method(class, method), do: "#{class}.#{method}"


  @doc """
  "0x1::Account::Balance<0x1::STC::STC>"
  """
  def build_resource_path(addr, module_name, func_name) when is_binary(module_name) do
    "#{addr}::#{module_name}::#{func_name}"
  end

  def build_resource_path(addr, module_names, func_name) when is_list(module_names) do
    module_names
    |> Enum.reduce("#{addr}::", fn module_name, acc ->
      acc <> "#{module_name}::"
    end)
    |> Kernel.<>("#{func_name}")
  end


end
