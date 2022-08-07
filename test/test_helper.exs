Mox.defmock(Web3MoveEx.HTTP.Mox, for: Web3MoveEx.HTTP)
Application.put_env(:web3_move_ex, :http, Web3MoveEx.HTTP.Mox)

ExUnit.start()
