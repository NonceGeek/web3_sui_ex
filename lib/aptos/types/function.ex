defmodule Web3MoveEx.Aptos.Types.Function do
  @moduledoc false

  defstruct address: nil,
            module: nil,
            name: nil,
            type_params: [],
            params: [],
            return: [],
            visibility: :public,
            is_entry: true

  def new(fields) do
    struct(__MODULE__, fields)
  end
end
