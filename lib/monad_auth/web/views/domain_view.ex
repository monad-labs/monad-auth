defmodule MonadAuth.Web.DomainView do
  use MonadAuth.Web, :view
  alias MonadAuth.Web.DomainView

  def render("index.json", %{domain: domain}) do
    %{data: render_many(domain, DomainView, "domain.json")}
  end

  def render("show.json", %{domain: domain}) do
    %{data: render_one(domain, DomainView, "domain.json")}
  end

  def render("domain.json", %{domain: domain}) do
    %{
      # id: domain.id,
      name: domain.name,
      # user_count: domain.user_count
    }
  end
end
