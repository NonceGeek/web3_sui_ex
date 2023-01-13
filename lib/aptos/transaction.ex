defmodule Web3MoveEx.Aptos.Transaction do
  @moduledoc false

  import Web3MoveEx.Aptos.Helpers

  alias Web3MoveEx.Aptos.Parser
  alias Web3MoveEx.Aptos.Types.{RawTransaction, TransactionPayload, TransactionAuthenticator}

  # 0xb5e97db07fa0bd0e5598aa3643a9bc6f6693bddc1a9fec9e674a461eaa00b193
  @prefix_raw_tx sha3_256("APTOS::RawTransaction")

  def signing_message(raw_tx) do
    encoded_tx = Bcs.encode(raw_tx)
    to_hex(@prefix_raw_tx <> encoded_tx)
  end

  @doc """
  Sign an ED25519 transaction.
  """
  def sign_ed25519(raw_tx, signing_key, simulate \\ false) do
    encoded_tx = Bcs.encode(raw_tx)

    ed25519_signature =
      if simulate do
        <<0::512>>
      else
        signing_message = @prefix_raw_tx <> encoded_tx
        ed25519_sign(signing_message, signing_key.private_key)
      end

    authenticator = %TransactionAuthenticator.Ed25519{
      public_key: signing_key.public_key,
      signature: ed25519_signature
    }

    signature = TransactionAuthenticator.encode({:ed25519, authenticator})

    encoded_tx <> signature
  end

  def make_raw_txn(account, chain_id, payload, options \\ []) do
    if is_nil(account.auth_key), do: throw(:missing_auth_key)
    if is_nil(account.sequence_number), do: throw(:missing_sequence_number)

    max_gas_amount = options[:max_gas_amount] || 2000
    gas_unit_price = options[:gas_unit_price] || 1000

    expiration_timestamp_secs =
      options[:expiration_timestamp_secs] ||
        Access.get(options, :expire_in_secs, 60) + System.system_time(:second)

    tagged_payload =
      case payload do
        %TransactionPayload.EntryFunction{} ->
          {:entry_function, payload}

        %TransactionPayload.Script{} ->
          {:script, payload}

        _ ->
          throw(:not_implemented)
      end

    %RawTransaction{
      sender: account.auth_key,
      sequence_number: account.sequence_number,
      payload: tagged_payload,
      max_gas_amount: max_gas_amount,
      gas_unit_price: gas_unit_price,
      expiration_timestamp_secs: expiration_timestamp_secs,
      chain_id: chain_id
    }
  end

  def script_function(address, module, function, type_arg_defs, args) do
    address_bytes = normalize_address!(address)

    type_args =
      for type_arg_def <- type_arg_defs do
        if is_binary(type_arg_def) do
          {:ok, type_arg} = Parser.parse_type_tag(type_arg_def)
          type_arg
        else
          type_arg_def
        end
      end

    %TransactionPayload.EntryFunction{
      address: address_bytes,
      module: to_string(module),
      function: to_string(function),
      type_args: type_args,
      args: args
    }
  end

  def script(code_bytes, type_arg_defs, args) do
    type_args =
      for type_arg_def <- type_arg_defs do
        if is_binary(type_arg_def) do
          {:ok, type_arg} = Parser.parse_type_tag(type_arg_def)
          type_arg
        else
          type_arg_def
        end
      end

    %TransactionPayload.Script{
      code: code_bytes,
      type_args: type_args,
      args: args
    }
  end
end
