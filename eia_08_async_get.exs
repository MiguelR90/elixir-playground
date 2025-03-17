defmodule FireNCollect do
  defp expensive_query(query, sleep_time \\ 1000) do
    Process.sleep(sleep_time)
    "#{query} result"
  end

  def async(query) do
    # NOTE: caller pid need to be retrieved outside spawn closure
    # otherwise we retrieve the worker pid instead of the caller pid
    caller = self()

    # NOTE: Do work and send result back to caller
    spawn(fn ->
      result = expensive_query(query)
      send(caller, {:query_result, result})
    end)
  end

  def get() do
    receive do
      {:query_result, result} -> result
      # FIXME: do we need error handling? and how to best impl?
      _ -> :error
    end
  end
end

Enum.map(1..10, &FireNCollect.async("query #{&1}"))
results = Enum.map(1..10, fn _ -> FireNCollect.get() end)
IO.inspect(results)
