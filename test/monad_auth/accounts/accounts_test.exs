defmodule MonadAuth.AccountsTest do
  use MonadAuth.DataCase

  alias MonadAuth.Accounts

  describe "domain" do
    alias MonadAuth.Accounts.Domain

    @valid_attrs %{name: "some name", user_count: 42}
    @update_attrs %{name: "some updated name", user_count: 43}
    @invalid_attrs %{name: nil, user_count: nil}

    def domain_fixture(attrs \\ %{}) do
      {:ok, domain} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_domain()

      domain
    end

    test "list_domain/0 returns all domain" do
      domain = domain_fixture()
      assert Accounts.list_domain() == [domain]
    end

    test "get_domain!/1 returns the domain with given id" do
      domain = domain_fixture()
      assert Accounts.get_domain!(domain.id) == domain
    end

    test "create_domain/1 with valid data creates a domain" do
      assert {:ok, %Domain{} = domain} = Accounts.create_domain(@valid_attrs)
      assert domain.name == "some name"
      assert domain.user_count == 42
    end

    test "create_domain/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_domain(@invalid_attrs)
    end

    test "update_domain/2 with valid data updates the domain" do
      domain = domain_fixture()
      assert {:ok, domain} = Accounts.update_domain(domain, @update_attrs)
      assert %Domain{} = domain
      assert domain.name == "some updated name"
      assert domain.user_count == 43
    end

    test "update_domain/2 with invalid data returns error changeset" do
      domain = domain_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_domain(domain, @invalid_attrs)
      assert domain == Accounts.get_domain!(domain.id)
    end

    test "delete_domain/1 deletes the domain" do
      domain = domain_fixture()
      assert {:ok, %Domain{}} = Accounts.delete_domain(domain)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_domain!(domain.id) end
    end

    test "change_domain/1 returns a domain changeset" do
      domain = domain_fixture()
      assert %Ecto.Changeset{} = Accounts.change_domain(domain)
    end
  end
end
