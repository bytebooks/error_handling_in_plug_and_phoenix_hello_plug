defmodule HelloPlug.Web do
  def init(opts), do: opts

  def call(conn, _opts), do: Plug.Conn.send_resp(conn, :ok, "Hello!")
end
