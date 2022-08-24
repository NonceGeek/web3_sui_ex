defmodule Web3MoveEx.Starcoin.Transaction do
  @moduledoc false

  import Web3MoveEx.Starcoin.Helpers

  alias Web3MoveEx.Starcoin.Parser

  alias Web3MoveEx.Starcoin.Transaction.{
    RawTransaction,
    TransactionPayload,
    TransactionAuthenticator
  }

  @prefix_raw_tx sha3_256("STARCOIN::RawUserTransaction")

  @doc """
  Signing message
  """
  def signing_message(raw_tx) do
    raw_tx
    |> Bcs.encode()
    |> to_hex()
  end

  @doc """
  Sign an ED25519 transaction.
  """
  def sign_ed25519(raw_tx, signing_key) do
    encoded_tx = Bcs.encode(raw_tx)
    signing_message = @prefix_raw_tx <> encoded_tx
    ed25519_signature = ed25519_sign(signing_message, signing_key.private_key)

    authenticator = %TransactionAuthenticator.Ed25519{
      public_key: signing_key.public_key,
      signature: ed25519_signature
    }

    signature = TransactionAuthenticator.encode({:ed25519, authenticator})

    (encoded_tx <> signature)
    |> to_hex()
  end

  def script_function(address, module, function, type_arg_defs, args) do
    {:ok, address_bytes} = normalize_address(address)

    type_args =
      for type_arg_def <- type_arg_defs do
        if is_binary(type_arg_def) do
          {:ok, type_arg} = Parser.parse_type_tag(type_arg_def)
          type_arg
        else
          type_arg_def
        end
      end

    %TransactionPayload.ScriptFunction{
      address: address_bytes,
      module: to_string(module),
      function: to_string(function),
      type_args: type_args,
      args: args
    }
  end

  def make_raw_txn(account, chain_id, payload, options \\ []) do
    if is_nil(account.public_key), do: throw(:missing_public_key)
    if is_nil(account.sequence_number), do: throw(:missing_sequence_number)

    max_gas_amount = options[:max_gas_amount] || 10_000_000
    gas_unit_price = options[:gas_unit_price] || 1
    expiration_timestamp_secs = options[:expiration_timestamp_secs] || 1_000

    %RawTransaction{
      sender: account.address,
      sequence_number: account.sequence_number,
      payload: payload,
      max_gas_amount: max_gas_amount,
      gas_unit_price: gas_unit_price,
      gas_token_code: "0x1::STC::STC",
      expiration_timestamp_secs: expiration_timestamp_secs,
      chain_id: chain_id
    }
  end

  def ed25519_sign(message, private_key) do
    :crypto.sign(:eddsa, :none, message, [private_key, :ed25519])
  end
end
