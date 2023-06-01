defmodule Web3SuiEx.SuiGetTest do
  @moduledoc false
  alias Web3SuiEx.Sui.RPC
  alias Web3SuiEx.Sui
  use ExUnit.Case, async: true
  require Logger

  setup_all do
    {:ok, rpc} = RPC.connect(:devnet)
    {:ok, %Web3SuiEx.Sui.Account{sui_address_hex: sui_address}} = Sui.gen_acct()
    %{rpc: rpc, address: sui_address}
  end

  test "get_gas_price", %{rpc: rpc} do
    {:ok, res} = Sui.suix_getReferenceGasPrice(rpc)
  end

  test "get_balance", %{rpc: rpc, address: account} do
    res = Sui.get_balance(rpc, account)

    assert {:ok,
            %{
              coinType: "0x2::sui::SUI",
              coinObjectCount: 0,
              totalBalance: 0,
              lockedBalance: {}
            }} == res
  end

  test "sui_getMoveFunctionArgTypes", %{rpc: rpc, address: account} do
    res = Sui.sui_getMoveFunctionArgTypes(rpc, "0x2", "pay", "split")

    assert res ==
             {:ok, [%{Object: "ByMutableReference"}, "Pure", %{Object: "ByMutableReference"}]}
  end

  test "sui_getNormalizedMoveFunction", %{rpc: rpc, address: account} do
    res = Sui.sui_getNormalizedMoveFunction(rpc, "0x2", "pay", "split")

    assert res ==
             {:ok,
              %{
                isEntry: true,
                parameters: [
                  %{
                    MutableReference: %{
                      Struct: %{
                        address: "0x2",
                        module: "coin",
                        name: "Coin",
                        typeArguments: [%{TypeParameter: 0}]
                      }
                    }
                  },
                  "U64",
                  %{
                    MutableReference: %{
                      Struct: %{
                        address: "0x2",
                        module: "tx_context",
                        name: "TxContext",
                        typeArguments: []
                      }
                    }
                  }
                ],
                return: [],
                typeParameters: [%{abilities: []}],
                visibility: "Public"
              }}

    res = Sui.sui_getNormalizedMoveFunction(rpc, "0x2", "sui", "transfer")

    assert res == {
             :ok,
             %{
               isEntry: true,
               parameters: [
                 %{
                   Struct: %{
                     address: "0x2",
                     module: "coin",
                     name: "Coin",
                     typeArguments: [
                       %{Struct: %{address: "0x2", module: "sui", name: "SUI", typeArguments: []}}
                     ]
                   }
                 },
                 "Address"
               ],
               return: [],
               typeParameters: [],
               visibility: "Public"
             }
           }
  end

  test "sui_getNormalizedMoveModule", %{rpc: rpc, address: account} do
    res = Sui.sui_getNormalizedMoveModule(rpc, "0x2", "pay")

    assert res ==
             {:ok,
              %{
                address: "0x2",
                exposedFunctions: %{
                  divide_and_keep: %{
                    isEntry: true,
                    parameters: [
                      %{
                        MutableReference: %{
                          Struct: %{
                            address: "0x2",
                            module: "coin",
                            name: "Coin",
                            typeArguments: [%{TypeParameter: 0}]
                          }
                        }
                      },
                      "U64",
                      %{
                        MutableReference: %{
                          Struct: %{
                            address: "0x2",
                            module: "tx_context",
                            name: "TxContext",
                            typeArguments: []
                          }
                        }
                      }
                    ],
                    return: [],
                    typeParameters: [%{abilities: []}],
                    visibility: "Public"
                  },
                  join: %{
                    isEntry: true,
                    parameters: [
                      %{
                        MutableReference: %{
                          Struct: %{
                            address: "0x2",
                            module: "coin",
                            name: "Coin",
                            typeArguments: [%{TypeParameter: 0}]
                          }
                        }
                      },
                      %{
                        Struct: %{
                          address: "0x2",
                          module: "coin",
                          name: "Coin",
                          typeArguments: [%{TypeParameter: 0}]
                        }
                      }
                    ],
                    return: [],
                    typeParameters: [%{abilities: []}],
                    visibility: "Public"
                  },
                  join_vec: %{
                    isEntry: true,
                    parameters: [
                      %{
                        MutableReference: %{
                          Struct: %{
                            address: "0x2",
                            module: "coin",
                            name: "Coin",
                            typeArguments: [%{TypeParameter: 0}]
                          }
                        }
                      },
                      %{
                        Vector: %{
                          Struct: %{
                            address: "0x2",
                            module: "coin",
                            name: "Coin",
                            typeArguments: [%{TypeParameter: 0}]
                          }
                        }
                      }
                    ],
                    return: [],
                    typeParameters: [%{abilities: []}],
                    visibility: "Public"
                  },
                  join_vec_and_transfer: %{
                    isEntry: true,
                    parameters: [
                      %{
                        Vector: %{
                          Struct: %{
                            address: "0x2",
                            module: "coin",
                            name: "Coin",
                            typeArguments: [%{TypeParameter: 0}]
                          }
                        }
                      },
                      "Address"
                    ],
                    return: [],
                    typeParameters: [%{abilities: []}],
                    visibility: "Public"
                  },
                  keep: %{
                    isEntry: false,
                    parameters: [
                      %{
                        Struct: %{
                          address: "0x2",
                          module: "coin",
                          name: "Coin",
                          typeArguments: [%{TypeParameter: 0}]
                        }
                      },
                      %{
                        Reference: %{
                          Struct: %{
                            address: "0x2",
                            module: "tx_context",
                            name: "TxContext",
                            typeArguments: []
                          }
                        }
                      }
                    ],
                    return: [],
                    typeParameters: [%{abilities: []}],
                    visibility: "Public"
                  },
                  split: %{
                    isEntry: true,
                    parameters: [
                      %{
                        MutableReference: %{
                          Struct: %{
                            address: "0x2",
                            module: "coin",
                            name: "Coin",
                            typeArguments: [%{TypeParameter: 0}]
                          }
                        }
                      },
                      "U64",
                      %{
                        MutableReference: %{
                          Struct: %{
                            address: "0x2",
                            module: "tx_context",
                            name: "TxContext",
                            typeArguments: []
                          }
                        }
                      }
                    ],
                    return: [],
                    typeParameters: [%{abilities: []}],
                    visibility: "Public"
                  },
                  split_and_transfer: %{
                    isEntry: true,
                    parameters: [
                      %{
                        MutableReference: %{
                          Struct: %{
                            address: "0x2",
                            module: "coin",
                            name: "Coin",
                            typeArguments: [%{TypeParameter: 0}]
                          }
                        }
                      },
                      "U64",
                      "Address",
                      %{
                        MutableReference: %{
                          Struct: %{
                            address: "0x2",
                            module: "tx_context",
                            name: "TxContext",
                            typeArguments: []
                          }
                        }
                      }
                    ],
                    return: [],
                    typeParameters: [%{abilities: []}],
                    visibility: "Public"
                  },
                  split_vec: %{
                    isEntry: true,
                    parameters: [
                      %{
                        MutableReference: %{
                          Struct: %{
                            address: "0x2",
                            module: "coin",
                            name: "Coin",
                            typeArguments: [%{TypeParameter: 0}]
                          }
                        }
                      },
                      %{Vector: "U64"},
                      %{
                        MutableReference: %{
                          Struct: %{
                            address: "0x2",
                            module: "tx_context",
                            name: "TxContext",
                            typeArguments: []
                          }
                        }
                      }
                    ],
                    return: [],
                    typeParameters: [%{abilities: []}],
                    visibility: "Public"
                  }
                },
                fileFormatVersion: 6,
                friends: [],
                name: "pay",
                structs: %{}
              }}
  end
end
