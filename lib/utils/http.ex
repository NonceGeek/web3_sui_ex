defmodule Web3MoveEx.HTTP do
  @moduledoc """
  http behaviour && get default impl
  """

  @callback json_rpc(
              method :: String.t(),
              param :: non_neg_integer() | list()
            ) ::
              map()

  @callback get(url :: String.t()) ::
              {:error, String.t()} | {:ok, any}

  @callback post(
              url :: String.t(),
              body :: String.t()
            ) ::
              {:error, String.t()} | {:ok, any}

  @callback post(
              url :: String.t(),
              body :: String.t(),
              options :: String.t()
            ) ::
              {:error, String.t()} | {:ok, any}

  alias Web3MoveEx.HTTPImpl

  def json_rpc(method, param), do: http_impl().json_rpc(method, param)

  def get(url), do: http_impl().get(url)

  def post(url, body), do: http_impl().post(url, body)
  def post(url, body, :urlencoded), do: http_impl().post(url, body, :urlencoded)

  defp http_impl() do
    Application.get_env(:web3_move_ex, :http, HTTPImpl)
  end
end
