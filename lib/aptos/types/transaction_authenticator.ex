defmodule Web3MoveEx.Aptos.Types.TransactionAuthenticator do
  @moduledoc false

  use Bcs.TaggedEnum, [
    {:ed25519, __MODULE__.Ed25519}
  ]

  defmodule Ed25519 do
    @derive {Bcs.Struct,
     [
       # public_key: Web3MoveEx.Aptos.Types.ed25519_key(),
       public_key: [:u8],
       # signature: Web3MoveEx.Aptos.Types.ed25519_signature(),
       signature: [:u8]
     ]}

    defstruct [:public_key, :signature]
  end
end
