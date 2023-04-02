defmodule Web3MoveEx.Sui.Bcs.TransactionKind do
  @moduledoc false
  alias __MODULE__.SingleTransactionKind
  alias __MODULE__.ObjectDigest
  alias __MODULE__.ObjectID
  alias __MODULE__.ObjectRef
  alias __MODULE__.ObjectDigest
  alias __MODULE__.TypeTag
  alias __MODULE__.CallArg
  alias Web3MoveEx.Sui.Bcs.SuiAddress
    use Bcs.TaggedEnum, [
             programmable_transaction: ProgrammableTransaction,
#             change_epoch: ChangeEpoch,
#             Genesis: Genesis,
#             consensus_commit_prologue: ConsensusCommitPrologue,
#             programmable_transaction: ProgrammableTransaction
             ]
  end
  def transfer_object(recipient, object_ref) do
      bytes = Bcs.encode(recipient)
      inputs = [{:pure, bytes},{:object, {:imm_or_owned_object, object_ref}}]
      commands = [[{:input, 1}], {:input, 0}]
      %ProgrammableTransaction{inputs: inputs, commands: commands}
  end
  defmodule ProgrammableTransaction do
    @derive {Bcs.Struct, [
      inputs: {:vector, CallArg},
      commands: {:vector, Command}
    ]}
    defstruct [
    :inputs,
    :commands
    ]
  end
  defmodule Command do
    use Bcs.TaggedEnum,[
      movecall: ProgrammableMoveCall,
      transfer_objects: {{:vector, Argument}, Argument},
      split_coins: {Argument, {:vector, Argument}},
      merge_coins: {Argument, {:vector, Argument}},
      publish: {{:vector, {:vector, :u8}}, {:vector, ObjectID}},
      make_move_vec: {TypeTag, {:vector, Argument}},
      upgrade: {{:vector, {:vector, :u8}}, {:vecotr, ObjectID}, ObjectID, Argument}
    ]
  end
  defmodule ProgrammableMoveCall do
    @derive {Bcs.Struct,[
        package: ObjectID,
        module: Identifier,
        function: Identifier,
        type_arguments: {:vector, TypeTag},
        arguments: {:vector, Argument}
    ]}
    defstruct [
     :package,
     :module,
     :function,
     :type_arguments,
     :arguments
    ]
  end
  defmodule Argument do
    use Bcs.TaggedEnum,[
     :gas_coin,
     input: :u16,
     result: :u16,
     nested_result: {:u16, :u16}
    ]
  end
  defmodule ObjectID do
    @derive {Bcs.Struct,
    [
      val: [:u8 | 32]
    ]
    }
    defstruct [
     :val
    ]
  end
  defmodule SequenceNumber do
    @derive {Bcs.Struct,
    [
      val: :u64
    ]}
    defstruct [
      :val
    ]
  end
  defmodule ObjectDigest do
    @derive {Bcs.Struct,
    [
      val: [:u8 | 32]
    ]
    }
    defstruct [
     :val
    ]
  end
     defmodule Identifier do
       @derive {Bcs.Struct,[
          id: :string
       ]}
       defstruct [
         :id
       ]
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
          address: SuiAddress
          ]
        }
        defstruct [
          :address
        ]
      end
      defmodule CallArg do
        use Bcs.TaggedEnum,[
           pure: {:vector, :u8},
           object: ObjectArg
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
        defstruct [
         :id,
         :initial_shared_version,
        :mutable
        ]
      end
      defmodule ObjectRef do
        @derive {Bcs.Struct,[
          ref: {ObjectID, SequenceNumber, ObjectDigest}
        ]}
        defstruct [
          :ref
        ]
    end
    defmodule TransferSui do
       @derive {Bcs.Struct,[
        recipient: SuiAddress,
        amount: :u64
       ]}
       defstruct [
         :recipient,
         :amount
       ]
    end
     defmodule Pay do
      @derive {Bcs.Struct, [
        coins: {:vector, ObjectRef},
        recipients: {:vector, SuiAddress},
        amounts: {:vector, :u64}
     ]}
      defstruct [
        :coins,
        :recipients,
        :amounts
      ]
     end
    defmodule PaySui do
      @derive {Bcs.Struct,[
       coins: {:vector, ObjectRef},
       recipients: {:vector, SuiAddress},
       amounts: {:vector, :u64}
      ]
      }
      defstruct [
        :coins,
        :recipients,
        :amounts
      ]
    end
   defmodule PayAllSui do
    @derive {Bcs.Struct,[
      coins: {:vector, ObjectRef},
      recipients: SuiAddress
    ]
    }
    defstruct [
     :coins,
     :recipients
    ]
    end


end