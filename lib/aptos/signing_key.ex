defmodule Web3MoveEx.Aptos.SigningKey do
  @moduledoc """
  An Ed25519 keypair.
  """

  import Web3MoveEx.Aptos.Helpers

  defstruct [:private_key, :public_key]

  def new() do
    {public_key, private_key} = ed25519_new()

    {:ok,
     %__MODULE__{
       private_key: private_key,
       public_key: public_key
     }}
  end

  def new(private_key) do
    with {:ok, private_key} <- normalize_key(private_key) do
      public_key = ed25519_public_key(private_key)

      {:ok,
       %__MODULE__{
         private_key: private_key,
         public_key: public_key
       }}
    end
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%{public_key: public_key}, _opts) do
      concat(["#Key<", to_hex(public_key), ">"])
    end
  end

  defimpl String.Chars do
    def to_string(%{public_key: public_key}) do
      to_hex(public_key)
    end
  end
end
