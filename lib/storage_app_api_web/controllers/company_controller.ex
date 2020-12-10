defmodule StorageAppWeb.CompanyController do
  use StorageAppWeb, :controller

  alias StorageApp.Companies
  alias StorageApp.Companies.Company

  action_fallback StorageAppWeb.FallbackController

  def index(conn, _params) do
    companies = Companies.list_companies()
    render(conn, "index.json", companies: companies)
  end

  def create(conn, %{"company" => company_params}) do
    with {:ok, %Company{} = company} <- Companies.create_company(company_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.company_path(conn, :show, company))
      |> render("show.json", company: company)
    end
  end

  def show(conn, %{"id" => id}) do
    company = Companies.get_company!(id)
    render(conn, "show.json", company: company)
  end

  def update(conn, %{"id" => id, "company" => company_params}) do
    company = Companies.get_company!(id)

    with {:ok, %Company{} = company} <- Companies.update_company(company, company_params) do
      render(conn, "show.json", company: company)
    end
  end

  def delete(conn, %{"id" => id}) do
    company = Companies.get_company!(id)

    with {:ok, %Company{}} <- Companies.delete_company(company) do
      send_resp(conn, :no_content, "")
    end
  end
end
