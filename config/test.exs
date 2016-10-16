use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :summit_chat, SummitChat.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Drop requirements for password hashing intensiveness.
config :comeonin, :bcrypt_log_rounds, 4
config :comeonin, :pbkdf2_rounds, 1

# Configure your database
config :summit_chat, SummitChat.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "password",
  database: "summit_chat_test",
  hostname: "172.17.0.2",
  pool: Ecto.Adapters.SQL.Sandbox
