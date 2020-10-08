defmodule Myclient.Oauth do
  use GenServer

  alias GenServer, as: GS
  alias Myclient.Oauth, as: W

  def client_id() do
    Application.get_env(:myclient, :oauth2)
    |> (fn %{client_id: client_id} -> client_id end).()
    |> case do
      {:system, lookup} -> System.get_env(lookup)
      t -> t
    end
  end

  def client_secret() do
    Application.get_env(:myclient, :oauth2)
    |> (fn %{client_secret: client_secret} -> client_secret end).()
    |> case do
      {:system, lookup} -> System.get_env(lookup)
      t -> t
    end
  end

  def redirect_uri() do
    Application.get_env(:myclient, :oauth2)
    |> (fn %{redirect_uri: redirect_uri} -> redirect_uri end).()
    |> case do
      {:system, lookup} -> System.get_env(lookup)
      t -> t
    end
  end

  def start_link() do
    {:ok, _pid} = GS.start_link(__MODULE__, [], name: __MODULE__)
  end

  # Get token by credentials for the first time
  def access_token_by_credentials() do
    GS.call(W, :access_token)
  end

  #Get token from state
  def access_token() do
    GS.call(W, :lookup_token)
  end

  def refresh_token(token_data) do
    GS.call(W, {:refresh_token, token_data})
  end

  ### Server Callbacks

  def init(_) do
    {:ok, %{}}
  end

  def handle_call(:lookup_token, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:access_token, _from, _state) do
    handle_fetch_call(:access_token)
  end

  def handle_call({:refresh_token, nil}, _from, state) do
    handle_fetch_call({:refresh_token, state["refresh_token"]})
  end

  def handle_call({:refresh_token, %{"refresh_token" => refresh_token}}, _from, _state) do
    handle_fetch_call({:refresh_token, refresh_token})
  end

  def handle_fetch_call(oauth_data) do
    oauth_data
    |> fetch_token
    |> (fn {200, token} -> {:reply, token, token} end).()
  end

  #Get refresh token from allegro
  def fetch_token({:refresh_token, refresh_token}) do
    Myclient.Api.post(
      "https://allegro.pl/auth/oauth/token?grant_type=refresh_token",
      %{grant_type: :refresh_token, refresh_token: refresh_token},
      basic_auth_header()
    )
  end

  #Get access token by credentials from allegro
  def fetch_token(:access_token) do
    Myclient.Api.post(
      "https://allegro.pl/auth/oauth/token?grant_type=client_credentials",
      %{
        client_id: client_id(),
        client_secret: client_secret(),
        grant_type: :client_credentials,
        redirect_uri: redirect_uri()
      },
      basic_auth_header()
    )
  end

  def basic_auth_header() do
    credentials = (client_id() <> ":" <> client_secret()) |> Base.encode64()
    [{"Authorization", "Basic #{credentials}"}]
  end



  def get_code() do
    IO.puts(client_id())
    IO.puts(redirect_uri())

    Myclient.Api.get(
      "https://allegro.pl/auth/oauth/authorize",
      %{client_id: client_id(), response_type: :code, redirect_uri: redirect_uri()}
    )
  end
end
