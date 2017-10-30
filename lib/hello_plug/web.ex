defmodule HelloPlug.Web do
  import Plug.Conn
  def init(opts), do: opts

  def call(conn, _opts) do
    try do
      conn = fetch_query_params(conn)

      cond do
        conn.method == "GET" and conn.params == %{} ->
          conn
          |> put_resp_content_type("text/html")
          |> send_resp(:ok, """
                       <!doctype html>
                       <form>
                       <input placeholder="First operand" name="op1" />
                       <input placeholder="Second operand" name="op2" />
                       <button type="submit">Add</button>
                       </form>
                       """)
        conn.method == "GET" ->
          {op1, ""} = conn.params["op1"] |> Integer.parse
          {op2, ""} = conn.params["op2"] |> Integer.parse

          conn
          |> put_resp_content_type("text/html")
          |> send_resp(:ok, """
                       <!doctype html>
                       <a href="/">Go back</a>
                       <p>The sum of #{op1} and #{op2} is #{op1+op2}</p>
                       """)
      end
      rescue
        err ->
          require Logger
          Logger.error("INPUT_ERROR #{inspect err}")
          send_resp(conn, :bad_request, """
                    <!doctype html>
                    <h1 style='color:red;'>Gimme integers!</h1>
                    """)
    end
  end

end
