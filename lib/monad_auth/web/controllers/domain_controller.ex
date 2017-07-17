defmodule MonadAuth.Web.DomainController do
  use MonadAuth.Web, :controller

  alias MonadAuth.Accounts
  alias MonadAuth.Accounts.Domain

  action_fallback MonadAuth.Web.FallbackController

  def index(conn, _params) do
    domain = Accounts.list_domain()
    render(conn, "index.json", domain: domain)
  end

  def create(conn, %{"domain" => domain_params}) do
    with {:ok, %Domain{} = domain} <- Accounts.create_domain(domain_params) do
      conn
      |> put_status(:created)
      # |> put_resp_header("location", domain_path(conn, :show, domain))
      |> render("show.json", domain: domain)
    end
  end

  def show(conn, %{"id" => id}) do
    domain = Accounts.get_domain!(id)
    case domain do
      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |>render(MonadAuth.Web.ErrorView, "404.json")
      _ ->
        render(conn, "show.json", domain: domain)
    end
  end

  def update(conn, %{"id" => id, "domain" => domain_params}) do
    domain = Accounts.get_domain!(id)

    with {:ok, %Domain{} = domain} <- Accounts.update_domain(domain, domain_params) do
      render(conn, "show.json", domain: domain)
    end
  end

  def delete(conn, %{"id" => id}) do
    domain = Accounts.get_domain!(id)
    with {:ok, %Domain{}} <- Accounts.delete_domain(domain) do
      send_resp(conn, :no_content, "")
    end
  end
end
