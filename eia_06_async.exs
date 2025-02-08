defmodule SyncRun do
  def run do
    func = fn query_def ->
      Process.sleep(2_000)
      "#{query_def} result"
    end

    Enum.each(1..5, fn _ -> func.("query") end)
  end
end

defmodule AsyncRun do
  def run do
  end
end

SyncRun.run()
