defmodule PingPong do
  def start do
    ping = spawn(__MODULE__, :ping, [])
    pong = spawn(__MODULE__, :pong, [])

    send ping, {pong, :ping}
  end

  def ping do
    receive do
      {pid, :ping} ->
        IO.puts "PING"
        send pid, {self, :pong}
        ping
      _ -> IO.puts "unknown message"
    end
  end

  def pong do
    receive do
      {pid, :pong} ->
        IO.puts "PONG"
        send pid, {self, :ping}
        pong
      _ -> IO.puts "unknown message"
    end
  end
end
