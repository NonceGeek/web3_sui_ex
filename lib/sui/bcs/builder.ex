defmodule Web3MoveEx.Sui.Bcs.Builder do
  @moduledoc false
  def object_id, do: [:u8 | 32]
  def seq_number, do: :u64
  def object_digest, do: [:u8 | 32]
  def identifier, do: :string
  def object_ref, do: {object_id(), seq_number(), object_digest()}
  def sui_address, do: [:u8 | 32]
  def account_address, do: sui_address
end
