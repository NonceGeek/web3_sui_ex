defmodule Web3MoveEx.Sui.Bcs.TransactionKind do
  alias Web3MoveEx.Sui.Bcs.ProgrammableTransaction
  @moduledoc false
  use Bcs.TaggedEnum,
    programmable_transaction: ProgrammableTransaction
  #             change_epoch: ChangeEpoch,
  #             Genesis: Genesis,
  #             consensus_commit_prologue: ConsensusCommitPrologue,
  #             programmable_transaction: ProgrammableTransaction
  def transfer_object(%Web3MoveEx.Sui.Account{sui_address: sui_address} = recipient, object_ref) do
    bytes = Bcs.encode(sui_address)
    inputs = [{:pure, bytes}, {:object, {:imm_or_owned_object, object_ref}}]
    commands = [[{:input, 1}], {:input, 0}]
    %ProgrammableTransaction{inputs: inputs, commands: commands}
  end
end
