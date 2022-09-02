defmodule Web3MoveEx.Starcoin do
  @moduledoc false

  alias Web3MoveEx.Starcoin.Account
  alias Web3MoveEx.Starcoin.Caller.Txpool
  alias Web3MoveEx.Starcoin.Transaction
  alias Web3MoveEx.Starcoin.Transaction.TransactionPayload

  def submit_txn(client, payload, options \\ []) do
    private_key = Keyword.get(options, :private_key, fetch_priv_key())
    {:ok, account} = Account.new(private_key, client)

    tagged_payload =
      case payload do
        %TransactionPayload.ScriptFunction{} ->
          {:script_function, payload}

        _ ->
          throw(:not_implemented)
      end

    raw_txn = Transaction.make_raw_txn(account, client.chain_id, tagged_payload, options)

    signed_txn = Transaction.sign_ed25519(raw_txn, account.signing_key)
    Txpool.submit_hex_transaction(client, signed_txn)
  end

  def deploy_contract(client, file_path, payload, options \\ []) do
    private_key = Keyword.get(options, :private_key, fetch_priv_key())
    {:ok, account} = Account.new(private_key, client)
    {:ok, code} = File.read(file_path)

    module = %TransactionPayload.Package.Module{bytes: code}

    package_payload = %TransactionPayload.Package{
      address: account.address,
      modules: [module],
      init_script: payload
    }

    raw_txn =
      Transaction.make_raw_txn(account, client.chain_id, {:package, package_payload}, options)

    signed_txn = Transaction.sign_ed25519(raw_txn, account.signing_key)
    Txpool.submit_hex_transaction(client, signed_txn)
  end

  def fetch_priv_key, do: Application.fetch_env(:web3_move_ex, :private_key)
end
