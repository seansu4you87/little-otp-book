defmodule Cache do
  use GenServer

  @name Cache

  ## Client API
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: @name])
  end

  def write(key, value) do
    GenServer.call(@name, {:write, key, value})
  end

  def read(key) do
    GenServer.call(@name, {:read, key})
  end

  def delete(key) do
    GenServer.call(@name, {:delete, key})
  end

  def clear do
    GenServer.call(@name, :clear)
  end

  def exist?(key) do
    case read(key) do
      nil -> false
      _   -> true
    end
  end

  ## GenServer Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:write, key, value}, _from, cache) do
    {:reply, :ok, Map.put(cache, key, value)}
  end
  def handle_call({:read, key}, _from, cache) do
    {:reply, cache[key], cache}
  end
  def handle_call({:delete, key}, _from, cache) do
    {:reply, :ok, Map.delete(cache, key)}
  end
  def handle_call(:clear, _from, _cache) do
    {:reply, :ok, %{}}
  end

  ## Helper Functions
end
