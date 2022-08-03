defmodule Constant do
  def endpoint(:local), do: "http://localhost:9851"
  def endpoint(:dev), do: ""
  def endpoint(:prod), do: ""
end
