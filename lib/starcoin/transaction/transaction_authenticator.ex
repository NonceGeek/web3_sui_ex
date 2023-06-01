defmodule Web3SuiEx.Starcoin.Transaction.TransactionAuthenticator do
  @moduledoc false

  use Bcs.TaggedEnum, [
    {:ed25519, __MODULE__.Ed25519}
  ]

  defmodule Ed25519 do
    @derive {Bcs.Struct,
             [
               public_key: [:u8],
               signature: [:u8]
             ]}

    defstruct [:public_key, :signature]
  end
end
