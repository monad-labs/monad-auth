defmodule MonadAuth.Web.DomainControllerTest do
  use MonadAuth.Web.ConnCase

  alias MonadAuth.Accounts
  alias MonadAuth.Accounts.Domain

  @create_attrs %{name: "some name", user_count: 42}
  @update_attrs %{name: "some updated name", user_count: 43}
  @invalid_attrs %{name: nil, user_count: nil}

  def fixture(:domain) do
    {:ok, domain} = Accounts.create_domain(@create_attrs)
    domain
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, domain_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates domain and renders domain when data is valid", %{conn: conn} do
    conn = post conn, domain_path(conn, :create), domain: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, domain_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "name" => "some name",
      "user_count" => 42}
  end

  test "does not create domain and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, domain_path(conn, :create), domain: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen domain and renders domain when data is valid", %{conn: conn} do
    %Domain{id: id} = domain = fixture(:domain)
    conn = put conn, domain_path(conn, :update, domain), domain: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, domain_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "name" => "some updated name",
      "user_count" => 43}
  end

  test "does not update chosen domain and renders errors when data is invalid", %{conn: conn} do
    domain = fixture(:domain)
    conn = put conn, domain_path(conn, :update, domain), domain: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen domain", %{conn: conn} do
    domain = fixture(:domain)
    conn = delete conn, domain_path(conn, :delete, domain)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, domain_path(conn, :show, domain)
    end
  end
end
