# Aptos

## Example

```elixir
import Web3MoveEx.Aptos

alias Web3MoveEx.Aptos

{:ok, rpc} = Aptos.RPC.connect()

{:ok, account} = Aptos.Account.from_private_key(your_private_key)
{:ok, account} = Aptos.load_account(rpc, account)

# Call function
f = ~A"0x1::coin::transfer<CoinType>(address,u64)"f

payload = Aptos.call_function(f, ["0x1::aptos_coin::AptosCoin"], [account.address, 100])

Aptos.submit_txn(rpc, account, payload)
```