defmodule Web3MoveEx.Sui.Bcs.TransactionData do
  alias Web3MoveEx.Sui.Bcs.GasData
  alias Web3MoveEx.Sui.Bcs.TransactionKind
  alias Web3MoveEx.Sui.Bcs.V1

  use Bcs.TaggedEnum,
    v1: V1

  def new(kind, sui_address_hex, gas, gas_budget, gas_price) do
    {:ok, sui_address} = :sui_nif.decode_pub(sui_address_hex)

    gas_data = %GasData{
      payment: [gas],
      owner: sui_address,
      price: gas_price,
      budget: gas_budget
    }

    %V1{
      kind: {:programmable_transaction, kind},
      sender: sui_address,
      gas_data: gas_data,
      expire: :none
    }
  end

  defmodule TransactionExpire do
    use Bcs.TaggedEnum, [
      :none,
      epoch: :u64
    ]
  end
end
