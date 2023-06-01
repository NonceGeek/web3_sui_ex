Mox.defmock(Web3SuiEx.HTTP.Mox, for: Web3SuiEx.HTTP)
Application.put_env(:web3_sui_ex, :http, Web3SuiEx.HTTP.Mox)

ExUnit.start()
