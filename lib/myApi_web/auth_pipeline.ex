defmodule MyApi.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :MyApi,
  module: MyApi.Guardian,
  error_handler: MyApi.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end


defmodule MyApi.AuthErrorHandler do
  import Plug.Conn

  def auth_error(conn, {type, _reason}, _opts) do
    body = Jason.encode!(%{error: to_string(type)})
    send_resp(conn, 401, body)
  end

end
