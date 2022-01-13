defmodule Fakeblog.Repo do
  use Ecto.Repo,
    otp_app: :fakeblog,
    adapter: Ecto.Adapters.SQLite3
end
