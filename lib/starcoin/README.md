// TODO: Intro about starcoin.

## Example

```elixir
	client = Web3SuiEx.Starcoin.Client.connect()

	payload =
		Web3SuiEx.Starcoin.Transaction.Function.call(
			client,
			"0x1::TransferScripts::peer_to_peer_v2",
			["0x1::STC::STC"],
			["0x0000000000000000000000000a550c18", 1]
		)

	options = [private_key: "<you_priv_key>"]

	Web3SuiEx.Starcoin.submit_txn(client, payload, options)
```

```elixir
	client = Web3SuiEx.Starcoin.Client.connect()

	payload =
		%Web3SuiEx.Starcoin.TransactionPayload.ScriptFunction{
		address: "0x52bfdf8638e3658bb9f00cc04ca98bdd",
		module: "MyCounter",
		function: "init_counter",
		type_args: [],
		args: []
	}
		
	options = [private_key: "<you_priv_key>"]

	Web3SuiEx.Starcoin.deploy_contract(client, payload, "", options)
```