defmodule Web3MoveEx.Sui.Bcs.TransactionData do
  alias Web3MoveEx.Sui.Bcs.SuiAddress
  alias __MODULE__.GasData
  alias Web3MoveEx.Sui.Bcs.TransactionKind.ObjectRef

   use Bcs.TaggedEnum,[
     v1: V1
   ]
def new(kind, signer, gas, gas_budget, gas_price) do
      gas_data = %GasData{
      payment: gas,
      owner: signer,
      price: gas_price,
      budget: gas_budget
      }
      %Web3MoveEx.Sui.Bcs.TransactionData.V1{kind: kind, sender: signer, gas_data: gas_data, expire: :none}
  end

  defmodule V1 do
  @moduledoc false
    @derive {Bcs.Struct,
           [
             kind: Web3MoveEx.Sui.Bcs.TransactionKind,
             sender: SuiAddress,
             gas_data: GasData,
             expire: TransactionExpire
           ]}

  defstruct [
    :kind,
    :sender,
    :gas_data,
    :expire
  ]
  end
  defmodule TransactionExpire do
     use Bcs.TaggedEnum,[
       :none,
       epoch: :u64
     ]
  end

  defmodule GasData do
    @derive {Bcs.Struct,[
      payment:  ObjectRef,
      owner: SuiAddress,
      price: :u64,
      budget: :u64
    ]
    }
    defstruct [
      :payment,
      :owner,
      :price,
      :budget
    ]
  end
  defmodule IntentMessage do
     @derive {Bcs.Struct,[
       intent: Intent,
       data: Web3MoveEx.Sui.Bcs.TransactionData
     ]}
     defstruct [
       :intent,
       :data
     ]
  end
  defmodule Intent do
      @derive {Bcs.Struct,[
        scope: :u8,
        version: :u8,
        app_id: :u8
      ]}
      defstruct [
      :scope,
      :version,
      :app_id
    ]
    def default(), do: %Intent{scope: 0, version: 0, app_id: 0}
    end
end
