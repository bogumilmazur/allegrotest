use Mix.Config

config :myclient,
  token: "",
  service_url: "https://api.allegro.pl",
  oauth2: %{
    client_id: "client id",
    client_secret: "client secret",
    redirect_uri: "http://localhost:4000",
    code: "B7Iplpe5tXxn5ZmPcUYigexn1d72npJY"
  }


#     config(:myclient, key: :value)
#
# And access this configuration in your application as:
#
#     Application.get_env(:myclient, :key)
#
# Or configure a 3rd-party app:
#
#     config(:logger, level: :info)
#

# Example per-environment config:
#
#     import_config("#{Mix.env}.exs")
