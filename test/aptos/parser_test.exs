defmodule Web3MoveEx.Aptos.ParserTest do
  use ExUnit.Case

  import Web3MoveEx.Aptos

  @moduletag :capture_log
  test "parse params" do
    f = ~A"0xdea79e568e00066f60fbfe6ac6d8a9ef2fabbeadc6aae1ec9158d50f6efe4ac8::addr_aggregator::create_addr_aggregator(u64,string)"f
    assert %Web3MoveEx.Aptos.Types.Function{
             address: <<222, 167, 158, 86, 142, 0, 6, 111, 96, 251, 254, 106, 198, 216, 169, 239, 47, 171, 190, 173, 198, 170, 225, 236, 145, 88, 213, 15, 110, 254, 74, 200>>,
             is_entry: true,
             module: "addr_aggregator",
             name: "create_addr_aggregator",
             params: [:u64, :string],
             return: [],
             type_params: [],
             visibility: :public}=f

    f = ~A"0xdea79e568e00066f60fbfe6ac6d8a9ef2fabbeadc6aae1ec9158d50f6efe4ac8::addr_aggregator::create_addr_aggregator(u64,vector<string>)"f
    assert %Web3MoveEx.Aptos.Types.Function{
             address: <<222, 167, 158, 86, 142, 0, 6, 111, 96, 251, 254, 106, 198, 216, 169, 239, 47, 171, 190, 173, 198, 170, 225, 236, 145, 88, 213, 15, 110, 254, 74, 200>>,
             is_entry: true,
             module: "addr_aggregator",
             name: "create_addr_aggregator",
             params: [:u64, {:vector, :string}],
             return: [],
             type_params: [],
             visibility: :public}=f
    ##
    f = ~A"0xdea79e568e00066f60fbfe6ac6d8a9ef2fabbeadc6aae1ec9158d50f6efe4ac8::addr_aggregator::create_addr_aggregator<u64, string>(u64, vector<string>)"f
    assert %Web3MoveEx.Aptos.Types.Function{
             address: <<222, 167, 158, 86, 142, 0, 6, 111, 96, 251, 254, 106, 198, 216, 169, 239, 47, 171, 190, 173, 198, 170, 225, 236, 145, 88, 213, 15, 110, 254, 74, 200>>,
             is_entry: true,
             module: "addr_aggregator",
             name: "create_addr_aggregator",
             params: [:u64, {:vector, :string}],
             return: [],
             type_params: [%{"constraints" => []}],
             visibility: :public}=f
  end
end
