defmodule Runner do
  def expensive_query(query, sleep_time \\ 500) when is_bitstring(query) do
    Process.sleep(sleep_time)
    "#{query} result"
  end

  def run_sync do
    Enum.each(1..5, &IO.puts(expensive_query("query #{&1}")))
  end

  def run_async do
    Enum.each(1..5, &spawn(fn -> IO.puts(expensive_query("query #{&1}")) end))
  end
end

IO.puts("Running sync...")
Runner.run_sync()
IO.puts("Running async...")
Runner.run_async()

# HACK: Prevent async call / process from exiting before seeing the result
Process.sleep(1_000)
