defmodule Myclient do

  @doc"""
  Send a GET request to the API

  ## Examples

      iex> Myclient.get("http://localhost:4000")
      {200, %{version: "0.1.0"}}

      defmodule Myclient do

        defdelegate get(url, query_params \\ %{}, headers \\ []), to: Myclient.Api
        defdelegate post(url, body \\ nil, headers \\ []), to: Myclient.Api

      end

  """
  defdelegate get(url, query_params \\ %{}, headers \\ []), to: Myclient.Api

  @doc"""
  Send a POST request to the API

  ## Examples

      iex> Myclient.Api.post("http://localhost:4000", %{version: "2.0.0"})
      {201, %{version: "2.0.0"}}

  """
  defdelegate post(url, body \\ nil, headers \\ []), to: Myclient.Api


  @doc"""
  Extract the current version

  ## Examples

      iex> Myclient.current_version()
      "0.1.0"

  """
  defdelegate current_version(), to: Myclient.Client

  @doc"""
  Set the next version

  ## Examples

      iex> Myclient.next_version("1.2.3")
      "1.2.3"

  """
  defdelegate next_version(version), to: Myclient.Client

end
