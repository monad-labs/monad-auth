defmodule MonadAuth.CassandraRepo do

  def opts() do
     keyspace = Application.fetch_env!(:xandra, :keyspace)
     [
       name: :xandra_pool,
       pool: DBConnection.Poolboy,
       after_connect: fn(conn) -> Xandra.execute(conn, "USE "<>keyspace) end
     ]
  end


  def all(table) do
    Xandra.execute!(:xandra_pool, "SELECT * FROM "<>table, _params = [], pool: DBConnection.Poolboy)
  end

  def get(table, keys) do
    Xandra.execute!(:xandra_pool, "SELECT * FROM "<>table<>gen_where(keys), _params = [], pool: DBConnection.Poolboy)
  end

  def gen_where({atom, value}) do
    new_value =
      case is_binary(value) do
        true -> "'"<>value<>"'"
        false -> to_string(value)
    end
    " WHERE " <> to_string(atom) <> " = " <> new_value
  end

  def gen_where([head | tail]) do
    {atom, value} = head
    new_value =
      case is_binary(value) do
        true -> "'"<>value<>"'"
        false -> to_string(value)
    end
    where = " WHERE " <> to_string(atom) <> " = " <> new_value
    gen_where(tail, where)
  end

  def gen_where([head | tail], where) do
    {atom, value} = head
    new_where = where <> " AND " <> to_string(atom) <> "=" <> to_string(value)
    gen_where(tail, new_where)
  end

  def gen_where([], where), do: where


  def insert_domain(changeset) do
    with {:ok, _changeset} <- insert_valid(changeset),
         {:ok, _result} <- gen_insert_query(changeset),
         do: {:ok, Ecto.Changeset.apply_changes(changeset)}

  end
  def insert_valid(changeset) do
    case changeset.valid? do
      true -> {:ok, changeset}
      false ->{:error, changeset}
    end
  end

  def gen_insert_query(changeset) do
    prepared_insert = Xandra.prepare!(:xandra_pool, "INSERT INTO domains (name) VALUES (:name) IF NOT EXISTS", pool: DBConnection.Poolboy)
    Xandra.execute(:xandra_pool, prepared_insert, changeset.params, pool: DBConnection.Poolboy)
  end

end
