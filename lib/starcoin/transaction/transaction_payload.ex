defmodule Web3MoveEx.Starcoin.Transaction.Payload do
  @moduledoc false

  defmodule ScriptFunction do
    @moduledoc false

    defstruct [
      :address,
      :module,
      :function,
      :ty_args,
      :args
    ]
  end
end
