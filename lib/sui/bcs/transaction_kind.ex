defmodule Web3SuiEx.Sui.Bcs.TransactionKind do
  alias Web3SuiEx.Sui.Bcs.ProgrammableTransaction
  @moduledoc false
  use Bcs.TaggedEnum,
    programmable_transaction: ProgrammableTransaction

  #             change_epoch: ChangeEpoch,
  #             Genesis: Genesis,
  #             consensus_commit_prologue: ConsensusCommitPrologue,
  #             programmable_transaction: ProgrammableTransaction
  def transfer_object(sui_address_hex, object_ref) do
    {:ok, sui_address} = :sui_nif.decode_pub(sui_address_hex)
    bytes = Bcs.encode(sui_address, Web3SuiEx.Sui.Bcs.Builder.sui_address())
    inputs = [{:pure, bytes}, {:object, {:imm_or_owned_object, object_ref}}]
    commands = [{:transfer_objects, {[{:input, 1}], {:input, 0}}}]
    %ProgrammableTransaction{inputs: inputs, commands: commands}
  end

  # pub fn move_call(
  #       package: ObjectID,
  #       module: Identifier,
  #       function: Identifier,
  #       type_arguments: Vec<TypeTag>,
  #       arguments: Vec<Argument>,
  #   ) -> Self {
  #       Command::MoveCall(Box::new(ProgrammableMoveCall {
  #           package,
  #           module,
  #           function,
  #           type_arguments,
  #           arguments,
  #       }))

  def move_call(sui_address_hex, object_id, module, function, type_arguments, arguments) do
    # {:ok, sui_address} = :sui_nif.decode_pub(sui_address_hex)
    # bytes = Bcs.encode(sui_address, Web3SuiEx.Sui.Bcs.Builder.sui_address)
    # inputs = [{:pure, bytes}, {:object, {:imm_or_owned_object, object_ref}}]
    # commands = [{:transfer_objects, {[{:input, 1}], {:input, 0}}}]
    # %ProgrammableTransaction{inputs: inputs, commands: commands}
  end
end
