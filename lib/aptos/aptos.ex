defmodule Web3MoveEx.Aptos do
  @moduledoc false

  import Web3MoveEx.Aptos.Helpers
  alias Web3MoveEx.Aptos.RPC

  @doc """
    `~A"0x1::coin::transfer<CoinType>(address,u64)"f`
  """
  defmacro sigil_A({:<<>>, _, [string]}, _modifiers) do
    {:ok, function} = Web3MoveEx.Aptos.Parser.parse_function(string)
    Macro.escape(function)
  end

  # usefull APIs
  def load_account(client, account) do
    with {:ok, loaded_account} <- RPC.get_account(client, account),
         %{authentication_key: auth_key, sequence_number: seq_num} <- loaded_account do
      {:ok, auth_key} = normalize_key(auth_key)
      sequence_number = String.to_integer(seq_num)

      case account do
        %{auth_key: ^auth_key} ->
          {:ok, %{account | sequence_number: sequence_number}}

        %{auth_key: nil} ->
          {:ok, %{account | auth_key: auth_key, sequence_number: sequence_number}}

        _ ->
          {:error, :auth_key_not_match}
      end
    else
      _ -> {:error, :load_failed}
    end
  end

  def submit_txn_with_auto_acct_updating(client, acct, payload, options \\ []) do
    {:ok, acct_ol} = load_account(client, acct)
    submit_txn(client, acct_ol, payload, options)
  end
  def submit_txn(client, acct, payload, options \\ []) do

    raw_txn =
      Web3MoveEx.Aptos.Transaction.make_raw_txn(acct, client.chain_id, payload, options)

    signed_txn = Web3MoveEx.Aptos.Transaction.sign_ed25519(raw_txn, acct.signing_key)
    Web3MoveEx.Aptos.RPC.submit_bcs_transaction(client, signed_txn)
  end

  def call_function(func, type_args, args) do
    encoded_args =
      func.params
      |> Web3MoveEx.Aptos.Types.strip_signers()
      |> Web3MoveEx.Aptos.Types.encode(args)

    Web3MoveEx.Aptos.Transaction.script_function(
      func.address,
      func.module,
      func.name,
      type_args,
      encoded_args
    )
  end
end

# {:ok, rpc} = Web3MoveEx.Aptos.RPC.connect()

# {:ok, account} = Web3MoveEx.Aptos.Account.from_private_key(your_private_key)
# {:ok, account} = Web3MoveEx.Aptos.load_account(rpc, account)

# f = %Web3MoveEx.Aptos.Types.Function{
#   address: 0x1,
#   is_entry: true,
#   module: "coin",
#   name: "transfer",
#   params: [:address, :u64, {:vector, :string}],
#   return: [],
#   type_params: [%{"constraints" => []}],
#   visibility: :public
# }

# payload = Web3MoveEx.Aptos.call_function(f, ["0x1::aptos_coin::AptosCoin"], [account.address, 100, ["abc","456"])
# Web3MoveEx.Aptos.submit_txn(rpc, account, payload)
