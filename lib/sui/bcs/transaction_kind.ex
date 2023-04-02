defmodule Web3MoveEx.Sui.Bcs.TransactionKind do
  @moduledoc false
  alias __MODULE__.SingleTransactionKind
  alias __MODULE__.TransferObject
  alias __MODULE__.MoveModulePublish
  alias __MODULE__.TransferSui
  alias __MODULE__.ObjectDigest
  alias __MODULE__.ObjectID
  alias __MODULE__.ObjectRef
  alias __MODULE__.MoveCall
  alias __MODULE__.MoveModulePublish
  alias __MODULE__.ObjectDigest
  alias __MODULE__.Pay
  alias __MODULE__.PaySui
  alias __MODULE__.PayAllSui
  alias __MODULE__.TypeTag
  alias __MODULE__.CallArg
  alias Web3MoveEx.Sui.Bcs.SuiAddress
  use Bcs.TaggedEnum, [
    single: SingleTransactionKind,
    batch: {:vector, SingleTransactionKind},
  ]
  defmodule SingleTransactionKind do
    use Bcs.TaggedEnum, [
             transfer_object: TransferObject,
             publish: MoveModulePublish,
             call: MoveCall,
             transfer_sui: TransferSui,
             pay: Pay,
             pay_sui: PaySui,
             pay_all_sui: PayAllSui
#             change_epoch: ChangeEpoch,
#             Genesis: Genesis,
#             consensus_commit_prologue: ConsensusCommitPrologue,
#             programmable_transaction: ProgrammableTransaction
             ]
  end
  defmodule TransferObject do
      @derive {Bcs.Struct,
      [
        recipient: SuiAddress,
        object_ref: ObjectRef
      ]
      }
  end

  defmodule ObjectID do
    @derive {Bcs.Struct,
    [
      {:struct, SuiAddress}
    ]
    }
  end
  defmodule SequenceNumber do
    @derive {Bcs.Struct,
    [
      :u64
    ]}
  end
  defmodule ObjectDigest do
    @derive {Bcs.Struct,
    [
      [:u8 | 32]
    ]
    }
  end
  defmodule MoveModulePublish do
    @derive {Bcs.Struct,
    [
      {:vector, {:vector, :u8}}
    ]

    }
    end
    defmodule MoveCall do
      @derive {Bcs.Struct,
      [
      package: ObjectID,
      module: Identifier,
      function: Identifier,
      type_arguments: {:vector, TypeTag},
      arguments: {:vector, CallArg}
      ]
      }
    end
     defmodule Identifier do
       @derive {Bcs.Struct,[
          :string
       ]}
     end
    defmodule TypeTag do
      use Bcs.TaggedEnum,[
        :bool,
        :u8,
        :u64,
        :u128,
        :address,
        :signer,
        {:vector, TypeTag},
        {:struct, StructTag},
        :u16,
        :u32,
        :u256
      ]
    end
      defmodule AccountAddress do
        @derive {
        Bcs.Struct,[
          SuiAddress
          ]
        }
      end
      defmodule CallArg do
        use Bcs.TaggedEnum,[
           pure: {:vector, :u8},
           object: ObjectArg,
           obj_vec: {:vector, ObjectArg}
        ]
      end
      defmodule ObjectArg do
        use Bcs.TaggedEnum,[
          imm_or_owned_object: ObjectRef,
          share_object: ShareObject
        ]
      end
      defmodule ShareObject do
        @derive {Bcs.Struct, [
         id: ObjectID,
         initial_shared_version: SequenceNumber,
         mutable: :bool
        ]}
      end
      defmodule ObjectRef do
        @derive {Bcs.Struct,[
          {ObjectID, SequenceNumber, ObjectDigest}
        ]}
    end
    defmodule TransferSui do
       @derive {Bcs.Struct,[
        recipient: SuiAddress,
        amount: :u64
       ]}
    end
     defmodule Pay do
      @derive {Bcs.Struct, [
        coins: {:vector, ObjectRef},
        recipients: {:vector, SuiAddress},
        amounts: {:vector, :u64}
     ]}
     end
    defmodule PaySui do
      @derive {Bcs.Struct,[
       coins: {:vector, ObjectRef},
       recipients: {:vector, SuiAddress},
       amounts: {:vector, :u64}
      ]
      }
    end
   defmodule PayAllSui do
    @derive {Bcs.Struct,[
      coins: {:vector, ObjectRef},
      recipients: SuiAddress
    ]
    }
   end
end