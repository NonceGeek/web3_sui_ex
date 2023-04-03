defmodule Web3MoveEx.Sui.Bcs.TransactionKind do
  alias Web3MoveEx.Sui.Bcs.ProgrammableTransaction
  @moduledoc false
  use Bcs.TaggedEnum,
    programmable_transaction: ProgrammableTransaction
  #             change_epoch: ChangeEpoch,
  #             Genesis: Genesis,
  #             consensus_commit_prologue: ConsensusCommitPrologue,
  #             programmable_transaction: ProgrammableTransaction
  def transfer_object(recipient, object_ref) do
    bytes = Bcs.encode(recipient)
    inputs = [{:pure, bytes}, {:object, {:imm_or_owned_object, object_ref}}]
    commands = [[{:input, 1}], {:input, 0}]
    %ProgrammableTransaction{inputs: inputs, commands: commands}
  end
end
