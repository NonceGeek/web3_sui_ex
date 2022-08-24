defmodule Web3MoveEx.Starcoin.SigningKey do
  @moduledoc """
  An Ed25519 keypair.
  """

  import Web3MoveEx.Starcoin.Helpers

  defstruct [
    :private_key,
    :public_key
  ]

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

  def ed25519_new() do
    :crypto.generate_key(:eddsa, :ed25519)
  end

  def ed25519_new(private_key) do
    :crypto.generate_key(:eddsa, :ed25519, private_key)
  end

  def ed25519_public_key(private_key) do
    {public_key, _} = ed25519_new(private_key)
    public_key
  end
end
