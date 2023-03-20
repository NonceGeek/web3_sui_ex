defmodule Web3MoveEx.Aptos.TypesTest do
  use ExUnit.Case

  alias Web3MoveEx.Aptos.Types.Encode

  @moduletag :capture_log

  doctest Encode

  test "module exists" do
    assert is_list(Encode.module_info())
  end
end
