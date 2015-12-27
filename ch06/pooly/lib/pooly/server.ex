defmodule Pooly.Server do
  use GenServer
  import Supervisor.Spec

  #######
  # API #
  #######
  def start_link(pools_config) do
    GenServer.start_link(__MODULE__, pools_config, name: __MODULE__)
  end

  def checkout(pool_name) do
    GenServer.call(:"#{pool_name}Server", :checkout) #2
  end

  def checkin(pool_name, worker_pid) do
    GenServer.cast(:"#{pool_name}Server", {:checkin, worker_pid})       #2
  end

  def status(pool_name) do
    GenServer.call(:"#{pool_name}Server", :status)   #2
  end

  #############
  # Callbacks #
  #############

  def init(pools_config) do                         #3
    pools_config |> Enum.each(fn(pool_config) ->    #3
      send(self, {:start_pool, pool_config})        #3
    end)                                            #3
    {:ok, pools_config}
  end

  def handle_info({:start_pool, pool_config}, state) do #4
    {:ok, _pool_sup} = Supervisor.start_child(
      Pooly.PoolsSupervisor,
      supervisor_spec(pool_config)
    )

    {:noreply, state}
  end

  #####################
  # Private Functions #
  #####################

  defp supervisor_spec(pool_config) do
    opts = [id: :"#{pool_config[:name]}Supervisor"]
    supervisor(Pooly.PoolSupervisor, [pool_config], opts)
  end

  ###############################################################################

end
