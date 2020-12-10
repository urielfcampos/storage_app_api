defmodule StorageAppWeb.CompanyView do
  use StorageAppWeb, :view
  alias StorageAppWeb.CompanyView

  def render("index.json", %{companies: companies}) do
    %{data: render_many(companies, CompanyView, "company.json")}
  end

  def render("show.json", %{company: company}) do
    %{data: render_one(company, CompanyView, "company.json")}
  end

  def render("company.json", %{company: company}) do
    %{id: company.id,
      name: company.name}
  end
end
